import SwiftUI

enum LumenPalette {
    static let ink = Color(red: 0.10, green: 0.11, blue: 0.11)
    static let mute = Color(red: 0.42, green: 0.44, blue: 0.44)
    static let linen = Color(red: 0.957, green: 0.945, blue: 0.925)
    static let teal = Color(red: 42 / 255, green: 111 / 255, blue: 111 / 255)
}

struct LumenGlassCard<Content: View>: View {
    var padded: Bool = true
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padded ? 16 : 0)
            .background(Color.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(LumenPalette.teal.opacity(0.28), lineWidth: 1)
            )
            .clipped()
    }
}

struct LumenArt: View {
    let name: String
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFill()
    }
}

struct LumenTealPill: View {
    let title: String
    var art: String = "ChromeGlassPill"
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Circle()
                    .fill(LumenPalette.teal)
                    .frame(width: 10, height: 10)
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.95), in: Capsule())
            .overlay(Capsule().stroke(LumenPalette.teal, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }
}

struct LumenMacroBar: View {
    let title: String
    let value: Double
    let aim: Double
    let unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.black)
                Spacer()
                Text("\(Int(value.rounded())) / \(Int(aim.rounded())) \(unit)")
                    .font(.system(size: 13, weight: .medium).monospacedDigit())
                    .foregroundStyle(Color.black)
            }
            ProgressView(value: Double(fraction))
                .tint(LumenPalette.teal)
        }
    }

    private var fraction: CGFloat {
        guard aim > 0 else { return 0 }
        return CGFloat(min(max(value / aim, 0), 1))
    }
}

struct LumenEmptyPane: View {
    let art: String
    let title: String
    let line: String

    var body: some View {
        VStack(spacing: 14) {
            Image(art)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            Text(title)
                .font(.system(.title3, design: .default).weight(.semibold))
                .foregroundStyle(LumenPalette.ink)
            Text(line)
                .font(.system(.subheadline, design: .default))
                .foregroundStyle(LumenPalette.mute)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
    }
}

struct LumenBackdrop: View {
    var body: some View {
        LumenPalette.linen
            .ignoresSafeArea()
            .overlay {
                Image("TextureMistLinen")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.28)
                    .allowsHitTesting(false)
            }
            .overlay {
                Image("TextureFrostPane")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.12)
                    .allowsHitTesting(false)
            }
            .clipped()
    }
}
