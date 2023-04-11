import QtQuick
import QtQuick.Controls

Item {
    width: 640
    height: 480
    signal exitClicked()

    Rectangle {
        id: idioma
        width: parent.width
        height: 50
        color: "#aaaaaa"
        border.color: "black"
        border.width: 1

        Text {
            id: idiomaText
            color: "#000000"
            text: qsTr("LANGUAGE")
            font.bold: true
            styleColor: "#000000"
            font.pointSize: 20
            anchors.centerIn: parent
        }
    }

    ListView {

        id: myListView
        width: parent.width
        height: parent.height - 50
        y: 50
        model: ListModel {
            ListElement {
                name: "English"
            }
            ListElement {
                name: "Portuguese"
            }
            ListElement {
                name: "Exit"
            }
        }
        delegate: Rectangle {
            width: myListView.width
            height: myListView.height / 7
            color: ListView.isCurrentItem ? "lightblue" : "white"
            border.color: "black"
            Text {
                text: name === "English" ? qsTr("English") : name === "Portugues" ? qsTr("Portuguese")  : name === "Exit" ? qsTr("Exit") : name
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
            text: "Subir"
            x: 25;y: 50
            height: 50
            width: 50
            opacity: 0
            onClicked: {
                if (myListView.currentIndex >= -1) {
                    myListView.currentIndex--;
                    if (myListView.currentIndex === -1) {
                        myListView.currentIndex = myListView.count - 1
                    }
                }
            }
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
            text: "Bajar"
            x: 5;y: 50
            height: 50
            width: 50
            opacity: 0
            onClicked: {
                if (myListView.currentIndex <= myListView.count - 1) {
                    myListView.currentIndex++;
                    if (myListView.currentIndex === myListView.count) {
                        myListView.currentIndex = 0
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
                    db.setLanguage(optionSelected)
                    if (optionSelected !== "Exit") {
                        db.updateLanguage(optionSelected)
                        console.log("La opcion seleccionada es:", optionSelected)
                    } else if (optionSelected === "Exit") {
                        onclicked: exitClicked()
                    }
                } else {
                    console.log("El valor de la opcion seleccionada no es valido");
                }
            }
        }
    }
}
