import QtQuick
import QtQuick.Controls

Item {
    width: 640
    height: 480
    signal exitClicked()
    signal outputClicked()
    signal metricsClicked()
    signal bypassClicked()
    signal standbyClicked()
    signal maintenanceClicked()
    signal languagesClicked()
    signal monitorToSettings()

    Rectangle {
        id: settings
        width: parent.width
        height: 50
        color: "#aaaaaa"
        border.color: "black"
        border.width: 1

        Text {
            id: settingtext
            color: "#000000"
            text: qsTr("MENU")
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
                name: "Home"
            }
            ListElement {
                name: "Language"
            }
            ListElement {
                name: "Output"
            }
            ListElement {
                name: "Metrics"
            }
            ListElement {
                name: "Bypass"
            }
            ListElement {
                name: "Stand By"
            }
            ListElement {
                name: "Maintenance"
            }
            ListElement {
                name: "Set default settings"
            }
        }
        delegate: Rectangle {
            width: myListView.width
            height: myListView.height / 8
            color: ListView.isCurrentItem ? "#add8e6" : "white"
            border.color: "black"
            Text {
                text: name === "Home" ? qsTr("Home") : name === "Language" ? qsTr("Languages") : name === "Output" ? qsTr("Output") : name === "Metrics" ? qsTr("Metrics") : name === "Bypass" ? qsTr("Bypass") : name === "Stand By" ? qsTr("StandBy") : name === "Maintenance" ? qsTr("Maintenance") : name === "Set default settings" ? qsTr("Set default settings") : name
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    myListView.currentIndex = index
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
            source: "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/arrow.jpg"
            width: 50
            x: 25;y: 50
            transformOrigin: Item.Center
            rotation: 270
        }

        Image {
            id: startop
            fillMode: Image.PreserveAspectFit
            source: "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/power.png"
            width: 50
            x: 25;y: 290
        }
        Button {
            text: "up"
            x: 25;y: 50
            height: 50
            width: 50
            opacity: 0
            onClicked: {
                if(idleTimer.getSleepi() === 0){
                    if (myListView.currentIndex >= -1) {
                        myListView.currentIndex--;
                        if (myListView.currentIndex === -1) {
                            myListView.currentIndex = myListView.count - 1
                        }
                    }
                }
                else{
                    console.log("screen waked")
                    idleTimer.setSleepi(0);
                }
            }
        }

        Button{
            id: poweroff
            width: arrow.width
            height: arrow.height
            opacity: 0
            x: 25;y: 290
            onClicked:{
                Qt.quit();
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
            source: "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/arrow.jpg"
            width: 50
            x: 5;y: 50
            transformOrigin: Item.Center
            rotation: 90
        }

        Image {
            id: settingsIcon
            fillMode: Image.PreserveAspectFit
            source: "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/enter.png"
            width: 50
            x: 5;y: 290
        }
        Button {
            text: "down"
            x: 5;y: 50
            height: 50
            width: 50
            opacity: 0
            onClicked: {
                if(idleTimer.getSleepi() === 0){
                    if (myListView.currentIndex <= myListView.count - 1) {
                        myListView.currentIndex++;
                        if (myListView.currentIndex === myListView.count) {
                            myListView.currentIndex = 0
                        }
                    }
                }
                else{
                    console.log("screen waked")
                    idleTimer.setSleepi(0);
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
                if(idleTimer.getSleepi() === 0){
                    myListView.forceActiveFocus()
                    var optionSelected = myListView.model.get(myListView.currentIndex).name
                    if (myListView.currentItem != null) {
                        if (optionSelected === "Home") {
                            onClicked: exitClicked()
                        }
                        else if (optionSelected === "Language") {
                            onClicked: languagesClicked()
                        }
                        else if (optionSelected === "Output") {
                            onClicked: outputClicked()
                        }
                        else if (optionSelected === "Metrics") {
                            onClicked: metricsClicked()
                        }
                        else if (optionSelected === "Bypass") {
                            onClicked: bypassClicked()
                        }
                        else if (optionSelected === "Stand By") {
                            onClicked: standbyClicked()
                        }
                        else if (optionSelected === "Maintenance") {
                            onClicked: maintenanceClicked()
                        }
                        else if (optionSelected === "Set default settings") {
                            onClicked: {
                                db.defSettings()
                            if(db.getLanguage === "Portuguese"){
                                translator.selectLanguage("pt_PT")
                            }
                            else{
                                translator.selectLanguage("")
                            }
                            exitClicked()
                            }
                        }
                    } else {
                    }
                }
                else{
                    console.log("screen waked")
                    idleTimer.setSleepi(0);
                }
            }
        }
    }
}