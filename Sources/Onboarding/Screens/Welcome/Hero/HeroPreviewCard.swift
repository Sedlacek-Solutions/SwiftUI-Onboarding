//
//  HeroPreviewCard.swift
//
//  Created by James Sedlacek on 7/5/26.
//

import SwiftUI

@MainActor
struct HeroPreviewCard {
    let accentColor: Color
}

@MainActor
extension HeroPreviewCard: View {
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Today")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                    Text("1,824 kcal")
                        .font(.title2.weight(.bold))
                }

                Spacer()

                Image(systemName: "sparkles")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(accentColor, in: Circle())
            }

            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(accentColor.opacity(0.16))
                .overlay {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 86, weight: .semibold))
                        .foregroundStyle(accentColor)
                }
                .aspectRatio(1, contentMode: .fit)

            VStack(spacing: 10) {
                HeroMacroRow(title: "Protein", value: "112g", color: accentColor)
                HeroMacroRow(title: "Carbs", value: "186g", color: .orange)
                HeroMacroRow(title: "Fat", value: "58g", color: .pink)
            }
        }
        .padding(22)
        .background(.background, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
        .shadow(color: .black.opacity(0.14), radius: 24, y: 14)
    }
}

@MainActor
private struct HeroMacroRow {
    let title: String
    let value: String
    let color: Color
}

@MainActor
extension HeroMacroRow: View {
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)

            Text(title)
                .font(.subheadline)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    HeroPreviewCard(accentColor: .mint)
        .padding()
}
