import QtQuick 2.9
import QtQuick.Window 2.3
import QtQml.Models 2.3
import QtQuick.Controls 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("QmlFilterTest")

    property string filterText: filterField.text

    DelegateModel {
        id: delegateModel

        model: NamesModel {}

        delegate: ItemDelegate {
            width: parent.width

            text: name.replace(new RegExp(filterText.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"), "ig"),
                               '<font color="red"><u>$&</u></font>')
        }

        groups: DelegateModelGroup {
            id: filterGroup
            name: "filter"
        }

        filterOnGroup: filterText.length > 0 ? "filter" : "items"

    }

    onFilterTextChanged:{
        var needleRegExp = new RegExp(filterText.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"), "ig");

        for(var i = 0; i < delegateModel.items.count; i ++) {
            var s = delegateModel.items.get(i);
            if(typeof(s.model.name) === "string") {
                if(needleRegExp.test(s.model.name)){
                    s.inFilter = true;
                } else {
                    s.inFilter = false;
                }
            }
        }
    }

    TextField {
        id: filterField
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        placeholderText: "Type to filter in " + delegateModel.items.count + " items.."
    }

    ListView {
        anchors {
            top: filterField.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        clip: true

        model: delegateModel

        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
