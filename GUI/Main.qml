import QtQuick
import "translations"

Item {
    visible: true
    property int larguraTela: 640
    property int alturaTela: 480
    property
    var states
    width: 640
    height: 480

    Rectangle {
        id: workspace
        anchors.fill: parent

        Loader {
            id: loader
            anchors.fill: parent
        }

        state: "monitor"
        states: [

            State {
                name: "booting"
                PropertyChanges {
                    target: loader
                    source: "booting.qml"

                }
            },

            State {
                name: "monitor"
                PropertyChanges {
                    target: loader
                    source: "MONITOR.qml"

                }
            },

            State {
                name: "settings"
                PropertyChanges {
                    target: loader
                    source: "settings.qml"

                }
            },

            State {
                name: "graphics"
                PropertyChanges {
                    target: loader
                    source: "grafic.qml"

                }
            },

            State {
                name: "languages"
                PropertyChanges {
                    target: loader
                    source: "languages.qml"

                }
            },

            State {
                name: "standby"
                PropertyChanges {
                    target: loader
                    source: "standby.qml"

                }
            },

            State {
                name: "output"
                PropertyChanges {
                    target: loader
                    source: "output.qml"

                }
            },

            State {
                name: "bypass"
                PropertyChanges {
                    target: loader
                    source: "bypass.qml"
                }
            },

            State {
                name: "metric"
                PropertyChanges {
                    target: loader
                    source: "metric.qml"

                }

            }
        ]

        Connections {
            target: loader.item
            onExitClicked: {
                workspace.state = "monitor"
            }
            onMonitorToSettings: {
                workspace.state = "settings"
            }
            onLanguagesClicked: {
                workspace.state = "languages"
            }
            onOutputClicked: {
                workspace.state = "output"
            }
            onMetricsClicked: {
                workspace.state = "metric"
            }
            onBypassClicked: {
                workspace.state = "bypass"
            }
            onStandbyClicked: {
                workspace.state = "standby"
            }
            onMaintenanceClicked: {
                workspace.state = "graphics"
            }
        }

        //        MouseArea  {
        //            anchors.fill: parent
        //            onClicked: {
        //                var states =["booting", "monitor", "settings", "graphics", "languages", "standby", "output", "bypass", "metric"]
        //                var nextIndex = (states.indexOf(parent.state)+1)%states.length
        //                parent.state = states[nextIndex]
        //            }
        //        }
    }
}
