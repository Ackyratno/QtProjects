pragma Singleton
import QtQuick

QtObject {

    readonly property color backgroundColor: "#121214"
    readonly property color surfaceColor: "#1E1E22"
    readonly property color surfaceHeaderColor: "#25252A"
    readonly property color cardBackgroundColor: "#2A2A30"
    readonly property color cardHoverColor: "#32323A"
    
    readonly property color primaryColor: "#6C5CE7"
    readonly property color primaryHoverColor: "#7D6EED"
    readonly property color accentColor: "#00CEC9"
    readonly property color dangerColor: "#FF7675"
    readonly property color dangerHoverColor: "#D63031"
    
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#A0A0AB"
    readonly property color textMuted: "#63636E"
    
    readonly property color borderColor: "#33333C"
    readonly property color borderFocusColor: "#6C5CE7"

    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 16
    readonly property int spacingLg: 24
    readonly property int spacingXl: 32

    readonly property int radiusSm: 6
    readonly property int radiusMd: 12
    readonly property int radiusLg: 16
    readonly property int radiusRound: 999

    readonly property string fontFamily: "Inter, Roboto, sans-serif"
    readonly property int fontSizeSm: 12
    readonly property int fontSizeBody: 14
    readonly property int fontSizeSubheading: 16
    readonly property int fontSizeHeading: 20
    readonly property int fontSizeTitle: 26
}
