import SwiftUI

struct SilhouetteView: View {
    var body: some View {
        Canvas { ctx, size in
            let a = Anatomy(in: size)
            let fill = GraphicsContext.Shading.color(.white)

            for jc in a.jointCircles {
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: jc.center.x - jc.radius,
                        y: jc.center.y - jc.radius,
                        width: jc.radius * 2,
                        height: jc.radius * 2
                    )),
                    with: fill
                )
            }

            ctx.fill(taperedLimb(from: a.leftShoulder, to: a.leftElbow,
                                 startRadius: a.upperArmR, endRadius: a.elbowR), with: fill)
            ctx.fill(taperedLimb(from: a.leftElbow, to: a.leftHand,
                                 startRadius: a.elbowR, endRadius: a.handR), with: fill)

            ctx.fill(taperedLimb(from: a.rightShoulder, to: a.rightElbow,
                                 startRadius: a.upperArmR, endRadius: a.elbowR), with: fill)
            ctx.fill(taperedLimb(from: a.rightElbow, to: a.rightHand,
                                 startRadius: a.elbowR, endRadius: a.handR), with: fill)

            ctx.fill(taperedLimb(from: a.leftHip, to: a.leftKnee,
                                 startRadius: a.thighR, endRadius: a.kneeR), with: fill)
            ctx.fill(taperedLimb(from: a.leftKnee, to: a.leftAnkle,
                                 startRadius: a.kneeR, endRadius: a.ankleR), with: fill)

            ctx.fill(taperedLimb(from: a.rightHip, to: a.rightKnee,
                                 startRadius: a.thighR, endRadius: a.kneeR), with: fill)
            ctx.fill(taperedLimb(from: a.rightKnee, to: a.rightAnkle,
                                 startRadius: a.kneeR, endRadius: a.ankleR), with: fill)

            ctx.fill(makeTorso(a: a, size: size), with: fill)

            var neck = Path()
            neck.move(to: a.neckTop)
            neck.addLine(to: a.neckBottom)
            ctx.stroke(neck, with: fill, style: StrokeStyle(lineWidth: a.neckW, lineCap: .round))

            ctx.drawLayer { layer in
                layer.translateBy(x: a.head.x, y: a.head.y)
                layer.rotate(by: .degrees(-6))
                layer.fill(
                    Path(ellipseIn: CGRect(
                        x: -a.headW / 2, y: -a.headH / 2,
                        width: a.headW, height: a.headH
                    )),
                    with: fill
                )
            }
        }
        .opacity(0.24)
        .blur(radius: 0.6)
    }

    private func taperedLimb(from a: CGPoint, to b: CGPoint,
                             startRadius r1: CGFloat, endRadius r2: CGFloat) -> Path {
        let dx = b.x - a.x
        let dy = b.y - a.y
        let len = max(sqrt(dx * dx + dy * dy), 0.0001)
        let nx = dx / len
        let ny = dy / len
        let px = -ny
        let py = nx

        let aL = CGPoint(x: a.x + px * r1, y: a.y + py * r1)
        let aR = CGPoint(x: a.x - px * r1, y: a.y - py * r1)
        let bL = CGPoint(x: b.x + px * r2, y: b.y + py * r2)
        let bR = CGPoint(x: b.x - px * r2, y: b.y - py * r2)

        var path = Path()
        path.move(to: aL)
        path.addLine(to: bL)
        path.addLine(to: bR)
        path.addLine(to: aR)
        path.closeSubpath()
        return path
    }

    private func makeTorso(a: Anatomy, size: CGSize) -> Path {
        let w = size.width
        let h = size.height
        let cx = a.cx

        var p = Path()
        p.move(to: a.leftShoulder)
        p.addLine(to: a.rightShoulder)
        p.addCurve(
            to: a.rightHip,
            control1: CGPoint(x: cx + w * 0.058, y: h * 0.310),
            control2: CGPoint(x: cx + w * 0.060, y: h * 0.450)
        )
        p.addLine(to: a.leftHip)
        p.addCurve(
            to: a.leftShoulder,
            control1: CGPoint(x: cx - w * 0.075, y: h * 0.450),
            control2: CGPoint(x: cx - w * 0.085, y: h * 0.310)
        )
        p.closeSubpath()
        return p
    }
}

private struct JointCircle {
    let center: CGPoint
    let radius: CGFloat
}

private struct Anatomy {
    let cx: CGFloat
    let head: CGPoint
    let headW: CGFloat
    let headH: CGFloat
    let neckTop: CGPoint
    let neckBottom: CGPoint
    let neckW: CGFloat

    let leftShoulder: CGPoint
    let rightShoulder: CGPoint
    let leftElbow: CGPoint
    let rightElbow: CGPoint
    let leftHand: CGPoint
    let rightHand: CGPoint
    let leftHip: CGPoint
    let rightHip: CGPoint
    let leftKnee: CGPoint
    let rightKnee: CGPoint
    let leftAnkle: CGPoint
    let rightAnkle: CGPoint

    let shoulderR: CGFloat
    let elbowR: CGFloat
    let handR: CGFloat
    let hipR: CGFloat
    let kneeR: CGFloat
    let ankleR: CGFloat
    let upperArmR: CGFloat
    let forearmR: CGFloat
    let thighR: CGFloat
    let calfR: CGFloat

    let jointCircles: [JointCircle]

    init(in size: CGSize) {
        let w = size.width
        let h = size.height
        cx = w / 2

        head = CGPoint(x: cx + 2, y: h * 0.103)
        headW = w * 0.085
        headH = w * 0.105

        neckTop = CGPoint(x: cx + 1, y: h * 0.165)
        neckBottom = CGPoint(x: cx + 1, y: h * 0.218)
        neckW = w * 0.038

        leftShoulder  = CGPoint(x: cx - w * 0.103, y: h * 0.245)
        rightShoulder = CGPoint(x: cx + w * 0.103, y: h * 0.225)

        leftElbow  = CGPoint(x: cx - w * 0.140, y: h * 0.388)
        leftHand   = CGPoint(x: cx - w * 0.118, y: h * 0.532)

        rightElbow = CGPoint(x: cx + w * 0.168, y: h * 0.396)
        rightHand  = CGPoint(x: cx + w * 0.082, y: h * 0.510)

        leftHip  = CGPoint(x: cx - w * 0.080, y: h * 0.510)
        rightHip = CGPoint(x: cx + w * 0.090, y: h * 0.532)

        leftKnee  = CGPoint(x: cx - w * 0.038, y: h * 0.715)
        leftAnkle = CGPoint(x: cx - w * 0.005, y: h * 0.910)

        rightKnee  = CGPoint(x: cx + w * 0.072, y: h * 0.720)
        rightAnkle = CGPoint(x: cx + w * 0.110, y: h * 0.918)

        shoulderR = w * 0.048
        elbowR    = w * 0.038
        handR     = w * 0.032
        hipR      = w * 0.078
        kneeR     = w * 0.048
        ankleR    = w * 0.038

        upperArmR = w * 0.046
        forearmR  = w * 0.036
        thighR    = w * 0.072
        calfR     = w * 0.046

        jointCircles = [
            JointCircle(center: leftShoulder,  radius: shoulderR),
            JointCircle(center: rightShoulder, radius: shoulderR),
            JointCircle(center: leftElbow,     radius: elbowR),
            JointCircle(center: rightElbow,    radius: elbowR),
            JointCircle(center: leftHand,      radius: handR),
            JointCircle(center: rightHand,     radius: handR),
            JointCircle(center: leftHip,       radius: hipR),
            JointCircle(center: rightHip,      radius: hipR),
            JointCircle(center: leftKnee,      radius: kneeR),
            JointCircle(center: rightKnee,     radius: kneeR),
            JointCircle(center: leftAnkle,     radius: ankleR),
            JointCircle(center: rightAnkle,    radius: ankleR),
        ]
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        SilhouetteView()
    }
}
