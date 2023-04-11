import QtQuick
import QtQuick.Controls

Item {
    width: 640
    height: 480
    signal exitClicked()
    property bool plus: false

    property int myNumber: db.getOutput()

    Rectangle {
        id: output
        width: parent.width
        height: 50
        color: "#aaaaaa"
        border.color: "black"
        border.width: 1

        Text {
            id: outputtext
            color: "#000000"
            text: qsTr("OUTPUT")
            font.bold: true
            styleColor: "#000000"
            font.pointSize: 20
            anchors.centerIn: parent
        }
    }

    Timer {
        id: timer
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            timer2.stop()
            if (buttonDown.pressed || upButton.pressed) {
                timer2.start()
            }
        }
    }

    Timer {
        id: timer2
        interval: 50
        repeat: true
        running: false
        onTriggered: {
            if (buttonDown.pressed) {
                increaseNumber()
            } else if (upButton.pressed) {
                decreaseNumber()
            } else {
                timer2.stop()
                timer.stop()
            }
        }
    }

    ListView {
        id: myListView
        width: parent.width
        height: parent.height - 50
        y: 50
        model: ListModel {
            ListElement {
                name: "Output"
            }
            ListElement {
                name: "Exit"
            }
        }
        delegate: Rectangle {
            id: rects
            width: myListView.width
            height: myListView.height / 7
            color: ListView.isCurrentItem ? "lightblue" : "white"
            border.color: "black"
            Text {
                text: name === "Output" ? "Output : " + myNumber.toString() : name === "Exit" ? qsTr("Exit") : name
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    myListView.currentIndex = index
                    console.log("La opcion seleccionada es:", name);
                }
            }
        }
    }

    function increaseNumber() {
        if (myNumber < 200) {
            myNumber = myNumber + 1
            db.setOutput(myNumber)
            db.updateOutput()
        }
    }

    function decreaseNumber() {
        if (myNumber > 0) {
            myNumber = myNumber - 1
            db.setOutput(myNumber)
            db.updateOutput()
        }
    }

    Rectangle {
        id: buttons2
        width: 80
        height: alturaTela - 100
        radius: 10
        border.color: "black"
        border.width: 1
        x: larguraTela - 60;y: 50

        Image {
            id: arrow2
            fillMode: Image.PreserveAspectFit
            source: "file:///home/jonathan/Desktop/GUI/imagens/arrow.jpg"
            width: 50
            x: 5;y: 50
            transformOrigin: Item.Center
            rotation: 90
        }

        Image {
            id: settingsIcon
            fillMode: Image.PreserveAspectFit
            source: "file:///home/jonathan/Desktop/GUI/imagens/enter.png"
            width: 50
            x: 5;y: 290
        }
        Button {
            id: buttonDown
            text: "down"
            x: 25;y: 50
            height: 50
            width: 50
            opacity: 0
            onClicked: {
                if (plus === false) {
                    if (myListView.currentIndex >= -1) {
                        myListView.currentIndex--;
                        if (myListView.currentIndex === -1) {
                            myListView.currentIndex = myListView.count - 1
                        }
                    }
                } else if (plus) {
                    increaseNumber()
                }
            }
            onPressedChanged: {
                if (plus) {
                    if (pressed) {
                        timer.start()
                    } else {
                        timer2.stop()
                    }
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
                myListView.forceActiveFocus()
                var optionSelected = myListView.model.get(myListView.currentIndex).name
                if (myListView.currentItem != null) {
                    console.log("La opcion seleccionada es:", optionSelected)
                    if (optionSelected === "Exit") {
                        onClicked: exitClicked()
                    }
                    else if (optionSelected === "Output") {
                        if (plus) {
                            plus = false
                            arrow2.source = "file:///home/jonathan/Desktop/GUI/imagens/arrow.jpg"
                            arrow.source = "file:///home/jonathan/Desktop/GUI/imagens/arrow.jpg"
                            arrow.rotation = 270
                        } else {
                            plus = true
                            arrow2.source = "file:///home/jonathan/Desktop/GUI/imagens/plus.png"
                            arrow.source = "file:///home/jonathan/Desktop/GUI/imagens/less.png"
                            arrow.rotation = 0
                        }

                    }
                }
            }
        }
    }

    Rectangle {
        id: buttons1
        width: 80
        height: alturaTela - 100
        radius: 10
        border.color: "black"
        border.width: 1
        x: -20;y: 50

        Image {
            id: arrow
            fillMode: Image.PreserveAspectFit
            source: "file:///home/jonathan/Desktop/GUI/imagens/arrow.jpg"
            width: 50
            x: 25;y: 50
            transformOrigin: Item.Center
            rotation: 270
        }

        Image {
            id: startop
            fillMode: Image.PreserveAspectFit
            source: "file:///home/jonathan/Desktop/GUI/imagens/power.png"
            width: 50
            x: 25;y: 290
        }
        Button {
            id: upButton
            text: "up"
            x: 25;y: 50
            height: 50
            width: 50
            opacity: 0
            onClicked: {
                if (plus === false) {
                    if (myListView.currentIndex >= -1) {
                        myListView.currentIndex--;
                        if (myListView.currentIndex === -1) {
                            myListView.currentIndex = myListView.count - 1
                        }
                    }
                } else if (plus) {
                    decreaseNumber()
                }
            }
            onPressedChanged: {
                if (plus) {
                    if (pressed) {
                        timer.start()
                    } else {
                        timer2.stop()
                    }
                }
            }
        }
    }
}
