pragma Singleton
import QtQuick

QtObject {
    id: root

    // ==========================================
    // Color Palette - Cybersecurity Dark Theme
    // ==========================================
    readonly property color background: "#0B0E14"
    readonly property color backgroundAlt: "#0F131C"
    readonly property color surface: "#151923"
    readonly property color surfaceElevated: "#1C2230"
    readonly property color surfaceHover: "#252D3E"
    readonly property color surfacePressed: "#181E2B"
    
    readonly property color border: "#252E40"
    readonly property color borderHover: "#37435C"
    readonly property color borderFocus: "#3B82F6"

    // Accents
    readonly property color primary: "#3B82F6"
    readonly property color primaryHover: "#60A5FA"
    readonly property color primaryPressed: "#2563EB"
    readonly property color primaryGlow: "#1E3A8A"

    readonly property color accent: "#10B981"
    readonly property color accentHover: "#34D399"
    readonly property color accentPressed: "#059669"

    // Status Colors
    readonly property color success: "#10B981"
    readonly property color warning: "#F59E0B"
    readonly property color danger: "#EF4444"
    readonly property color info: "#38BDF8"

    // Typography Colors
    readonly property color textPrimary: "#F9FAFB"
    readonly property color textSecondary: "#9CA3AF"
    readonly property color textMuted: "#6B7280"
    readonly property color textInverse: "#0B0E14"
    readonly property color textAccent: "#60A5FA"

    // ==========================================
    // Typography Scale & Fonts
    // ==========================================
    readonly property string fontFamily: "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif"
    readonly property string fontFamilyMono: "'JetBrains Mono', 'Fira Code', Consolas, monospace"

    readonly property int fontSizeXs: 11
    readonly property int fontSizeSm: 13
    readonly property int fontSizeMd: 14
    readonly property int fontSizeLg: 16
    readonly property int fontSizeXl: 20
    readonly property int fontSizeH2: 24
    readonly property int fontSizeH1: 30

    // ==========================================
    // Spacing & Layout
    // ==========================================
    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 12
    readonly property int spacingLg: 16
    readonly property int spacingXl: 24
    readonly property int spacing2Xl: 32
    readonly property int spacing3Xl: 48

    // ==========================================
    // Border Radius
    // ==========================================
    readonly property int radiusSm: 6
    readonly property int radiusMd: 10
    readonly property int radiusLg: 14
    readonly property int radiusXl: 20
    readonly property int radiusFull: 9999

    // ==========================================
    // Animation Durations & Easings
    // ==========================================
    readonly property int animFast: 150
    readonly property int animNormal: 250
    readonly property int animSlow: 400
}
