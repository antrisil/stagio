import QtQuick
import QtQuick.Controls
import QtCharts
import "translations"

Item {
    width: 640
    height: 480
    property
    var length;
    property
    var table
    property bool realTime: true
    property variant ticks
    property
    var position
    property
    var date0
    property string period: tableSelector.currentText
    property int i
    property int currentComb: 0
    property bool sele: false

    signal exitClicked()

    ChartView {
        id: chartView
        width: parent.width * 0.85
        height: parent.height * 0.90
        anchors.horizontalCenter: parent.horizontalCenter
        antialiasing: true

        ValueAxis {
            id: xAxis
        }
        ValueAxis {
            id: yAxis
            max: 200
        }

        LineSeries {
            id: lineSeries
            name: qsTr("Load")
            visible: false
            axisX: CategoryAxis {
                id: axisLabels
                min: 0
                max: xAxis.max
                labelsPosition: CategoryAxis.AxisLabelsPositionOnValue
                labelsAngle: 0
            }
            axisY: yAxis
        }

        ValueAxis {
            id: xAxis2
        }
        ValueAxis {
            id: yAxis2
        }

        LineSeries {
            id: lineSeries2
            name: "Load"
            visible: true
            axisX: CategoryAxis {
                id: axisLabels2
                min: xAxis2.min
                max: xAxis2.max
                labelsPosition: CategoryAxis.AxisLabelsPositionOnValue
                labelsAngle: 0
            }

        }
        Component.onCompleted: {
            table = db.getLoad()
            for (i = 0; i < table.length; ++i) {
                lineSeries2.append(i, table[i])
            }

            db.LoadChanged.connect(function () {
                if (realTime) {
                    table = db.getLoad()
                    updateChart(table)
                }
            })
        }
    }

    function updateChart(table) {
        lineSeries2.clear()
        for (i = 0; i < table.length; i++) {
            switchPeriod(i)
            lineSeries2.append(i, table[i])

        }
    }

    function switchPeriod(i) {
        switch (period) {
        case "1M":
            if (i >= 60) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 60
            } else {
                xAxis2.max = 60
                xAxis2.min = 0
            }

            break
        case "5M":
            if (i >= 300) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 300
            } else {
                xAxis2.max = 300
                xAxis2.min = 0
            }

            break
        case "10M":
            if (i >= 600) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 600
            } else {
                xAxis2.max = 600
                xAxis2.min = 0
            }
            break
        case "30M":
            if (i >= 1800) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 1800
            } else {
                xAxis2.max = 1800
                xAxis2.min = 0
            }
            break
        case "1H":
            if (i >= 3600) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 3600
            } else {
                xAxis2.max = 3600;
                xAxis2.min = 0;
            }
            break
        case "2H":
            if (i >= 7200) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 7200
            } else {
                xAxis2.max = 7200
                xAxis2.min = 0
            }
            break
        case "5H":
            if (i >= 18000) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 18000
            } else {
                xAxis2.max = 18000
                xAxis2.min = 0
            }
            break;
        case "12H":
            if (i >= 43200) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 43200
            } else {
                xAxis2.max = 43200
                xAxis2.min = 0
            }
            break
        case "1D":
            if (i >= 86400) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 86400
            } else {
                xAxis2.max = 86400
                xAxis2.min = 0
            }
            break
        case "3D":
            if (i >= 259200) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 259200
            } else {
                xAxis2.max = 259200
                xAxis2.min = 0
            }
            break
        case "1W":
            if (i >= 604800) {
                xAxis2.max = lineSeries2.count
                xAxis2.min = lineSeries2.count - 604800
            } else {
                xAxis2.max = 604800
                xAxis2.min = 0
            }
            break
        default:
            return
        }
    }

    Rectangle {
        id: selectTime
        x: (parent.width * 0.5) - 140
        y: parent.height * 0.88
        ComboBox {
            id: tableSelectorTime
            width: 60
            height: 25
            model: ["1M", "5M", "10M", "30M", "1H", "2H", "5H", "12H", "1D", "3D", "1W"]
            background: Rectangle {
                id: selectTimecolor
                color: "#add8e6"
                border.width: 1
                radius: 5
            }

            Component.onCompleted: {
                period = tableSelectorTime.currentText
                updateChartForperiod(period)
            }

            onActivated: {
                period = tableSelectorTime.currentText
                updateChartForperiod(period)
                updateChart(date0)
            }
        }
    }

    function updateChartForperiod(period) {
        console.log(period)
        switch (period) {
        case "1M":
            console.log(i)
            removeLabels()
            xAxis2.max = 60
            xAxis.max = 60
            ticks = ["0", "15", "30", "45", "60"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            console.log("entrou")
            break
        case "5M":
            removeLabels()
            xAxis2.max = 300
            xAxis.max = 300
            ticks = ["0", "1", "2", "3", "4", "5"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            break
        case "10M":
            removeLabels()
            xAxis2.max = 600
            xAxis.max = 600
            ticks = ["0", "2", "4", "6", "8", "10"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            break

        case "30M":
            removeLabels()
            xAxis2.max = 1800
            xAxis.max = 1800
            ticks = ["0", "5", "10", "15", "20", "25", "30"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            break

        case "1H":
            removeLabels()
            xAxis2.max = 3600
            xAxis.max = 3600
            ticks = ["0", "10", "20", "30", "40", "50", "60"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            break

        case "2H":
            removeLabels()
            xAxis2.max = 7200
            xAxis.max = 7200
            ticks = ["0", "30", "60", "90", "120"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            break

        case "5H":
            removeLabels()
            xAxis2.max = 18000
            xAxis.max = 18000
            ticks = ["0", "1", "2", "3", "4", "5"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            break

        case "12H":
            removeLabels()
            xAxis2.max = 43200
            xAxis.max = 43200
            ticks = ["0", "2", "4", "6", "8", "10", "12"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            break;

        case "1D":
            removeLabels();
            xAxis2.max = 86400
            xAxis.max = 86400
            ticks = ["0", "4", "8", "12", "16", "20", "24"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            break

        case "3D":
            removeLabels()
            xAxis2.max = 259200
            xAxis.max = 259200
            ticks = ["0", "12H", "1D", "1D:12H", "2D", "2D:12H", "3D"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            break

        case "1W":
            removeLabels()
            xAxis2.max = 604800
            xAxis.max = 604800
            ticks = ["1", "2", "3", "4", "5", "6", "7"]
            addLabels(ticks, xAxis2.max)
            switchPeriod(i)
            break

        default:
            return
        }
    }

    function addLabels(ticks, max) {
        position = max / (ticks.length - 1)
        for (var i = 0; i < ticks.length; i++) {
            axisLabels.append(ticks[i], position * i);
        }
    }

    function removeLabels() {
        var label_strings = axisLabels.categoriesLabels
        while (axisLabels.count) {
            axisLabels.remove(label_strings[0])
        }
    }

    Rectangle {
        id: select
        x: parent.width - ((parent.width * 0.50) + 75)
        y: parent.height * 0.88
        ComboBox {
            id: tableSelector
            width: 150
            height: 25
            model: []
            background: Rectangle {
                id: colorboxSelector
                color: "#f0f8ff"
                border.width: 1
                radius: 5

            }

            Component.onCompleted: {
                updateTableList()
            }

            function updateTableList() {
                model = db.selectAllTables()
            }

            onActivated: {
                var currentTable = tableSelector.currentText
                date0 = db.loadParameter(currentTable)
                if (currentTable === db.getlast) {
                    realTime = true
                } else {
                    realTime = false
                    console.log(table)
                    date0.reverse()
                    console.log(table)
                }
                updateChart(date0)
            }
        }
    }

    Rectangle {
        id: buttonExit
        x: (parent.width * 0.5) + 80
        y: parent.height * 0.88

        Button {
            id: buttonExit0
            width: 70
            height: 25
            text: qsTr("Exit")
            background: Rectangle {
                id: buttonExit0color
                color: "#f0f8ff"
                border.width: 1
                radius: 5
            }
            onClicked: {
                onClicked: exitClicked()
            }
        }

    }

    Rectangle {
        id: buttons1
        width: parent.width * 0.1
        height: parent.height * 0.8
        radius: 10
        border.color: "black"
        border.width: 1
        x: parent.width - (parent.width * 1.02);y: parent.height * 0.10

        Image {
            id: return0
            fillMode: Image.PreserveAspectFit
            source: "file:///home/jonathan/Desktop/GUI/imagens/arrow.jpg"
            rotation: 180
            width: 50
            x: buttons2.width / 2 - 20;y: buttons2.height * 0.25 - 50
        }

        Image {
            id: startop
            fillMode: Image.PreserveAspectFit
            source: "file:///home/jonathan/Desktop/GUI/imagens/power.png"
            width: 50
            x: buttons2.width / 2 - 20;y: buttons2.height * 0.75

        }
        Button {
            text: "Subir"
            x: 25;y: 50
            height: 50
            width: 50
            opacity: 0
            onClicked: {
                if (currentComb === 1 && sele === false || currentComb === 2 && sele === false) {
                    currentComb--
                } else if (currentComb === 0 && sele === false) {
                    currentComb = 2
                } else if (currentComb === 0 && sele) {
                    if (tableSelectorTime.currentIndex === 0) {
                        tableSelectorTime.currentIndex = tableSelectorTime.count - 1
                    } else {
                        tableSelectorTime.currentIndex--
                    }
                } else if (currentComb === 1 && sele) {
                    if (tableSelector.currentIndex > 0) {
                        tableSelector.currentIndex--
                    } else {
                        tableSelector.currentIndex = tableSelector.count - 1
                    }
                }
                if (currentComb === 0 && sele === false) {
                    selectTimecolor.color = "#add8e6"
                } else if (currentComb != 0) {
                    selectTimecolor.color = "#f0f8ff"
                }
                if (currentComb === 1 && sele === false) {
                    colorboxSelector.color = "#add8e6"
                } else if (currentComb != 1) {
                    colorboxSelector.color = "#f0f8ff"
                }
                if (currentComb === 2 && sele === false) {
                    buttonExit0color.color = "#add8e6"
                } else if (currentComb != 2) {
                    buttonExit0color.color = "#f0f8ff"
                }

            }
        }
    }

    Rectangle {
        id: buttons2
        width: parent.width * 0.1
        height: parent.height * 0.8
        radius: 10
        border.color: "black"
        border.width: 1
        x: parent.width - (parent.width * 0.08);y: parent.height * 0.10
        Image {
            id: home
            fillMode: Image.PreserveAspectFit
            source: "file:///home/jonathan/Desktop/GUI/imagens/arrow.jpg"
            width: 50
            x: buttons2.width / 2 - 30;y: buttons2.height * 0.25 - 50
        }

        Image {
            id: settingsIcon
            fillMode: Image.PreserveAspectFit
            source: "file:///home/jonathan/Desktop/GUI/imagens/enter.png"
            width: 50
            x: buttons2.width / 2 - 30;y: buttons2.height * 0.75

        }

        Button {
            text: "Bajar"
            x: 5;y: 50
            height: 50
            width: 50
            opacity: 0
            onClicked: {
                if (currentComb === 0 && sele === false || currentComb === 1 && sele === false) {
                    currentComb++
                } else if (currentComb === 0 && sele) {
                    if (tableSelectorTime.currentIndex < tableSelectorTime.count - 1) {
                        tableSelectorTime.currentIndex++
                    } else {
                        tableSelectorTime.currentIndex = 0
                    }
                } else if (currentComb === 1 && sele) {
                    if (tableSelector.currentIndex < tableSelector.count - 1) {
                        tableSelector.currentIndex++
                    } else {
                        tableSelector.currentIndex = 0
                    }
                } else if (currentComb == 2 && sele === false) {
                    currentComb = 0
                }
                if (currentComb === 0 && sele === false) {
                    selectTimecolor.color = "#add8e6"
                } else if (currentComb != 0) {
                    selectTimecolor.color = "#f0f8ff"
                }
                if (currentComb === 1 && sele === false) {
                    colorboxSelector.color = "#add8e6"
                } else if (currentComb != 1) {
                    colorboxSelector.color = "#f0f8ff"
                }
                if (currentComb === 2 && sele === false) {
                    buttonExit0color.color = "#add8e6"
                } else if (currentComb != 2) {
                    buttonExit0color.color = "#f0f8ff"
                }
            }
        }

        Button {
            text: "Seleccionar"
            width: 50
            height: 50
            x: 5;y: 290
            opacity: 0
            onClicked: {
                if (currentComb === 0 && sele === false) {
                    sele = true
                    home.rotation = 90
                    return0.rotation = 270
                    selectTimecolor.color = "#87cefa"
                } else if (currentComb === 0 && sele === true) {
                    sele = false
                    home.rotation = 0
                    return0.rotation = 180
                    selectTimecolor.color = "#add8e6"
                    period = tableSelectorTime.currentText
                    updateChartForperiod(period)
                    updateChart(date0)
                } else if (currentComb === 1 && sele === false) {
                    sele = true
                    home.rotation = 90
                    return0.rotation = 270
                    colorboxSelector.color = "#87cefa"
                } else if (currentComb === 1 && sele === true) {
                    sele = false
                    home.rotation = 0
                    return0.rotation = 180
                    colorboxSelector.color = "#add8e6"
                    var currentTable = tableSelector.currentText
                    date0 = db.loadParameter(currentTable)
                    if (currentTable === db.getlast) {
                        realTime = true
                    } else {
                        realTime = false
                        console.log(table)
                        date0.reverse()
                        console.log(table)
                    }
                    updateChart(date0)
                } else if (currentComb === 2) {
                    buttonExit0.clicked()
                }

            }
        }
    }
}
