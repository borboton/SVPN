var cars = ["BMW", "Volvo", "Saab", "Ford"];
var text = "";
var i;
for (i = 0; i < cars.length; i++) {

    text += cars[i] + "<br>";
}
console.log(text);

var a = ["a", "b", "c"];

a.forEach(function(entry) {
    console.log(entry);


});


var tablearea = document.getElementById('tablearea'),
    table = document.createElement('table');

for (var i = 1; i < 4; i++) {
    var tr = document.createElement('tr');

    tr.appendChild( document.createElement('td') );
    tr.appendChild( document.createElement('td') );

    tr.cells[0].appendChild( document.createTextNode('Text1') )
    tr.cells[1].appendChild( document.createTextNode('Text2') );

    table.appendChild(tr);
}
tablearea.appendChild(table);

function addRow(tableID) {

    var table = document.getElementById(tableID);
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);

    var colCount = table.rows[0].cells.length;

    for(var i=0; i<colCount; i++) {

        var newcell = row.insertCell(i);

        newcell.innerHTML = table.rows[0].cells[i].innerHTML;
        //alert(newcell.childNodes);
        switch(newcell.childNodes[0].type) {
            case "text":
                    newcell.childNodes[0].value = "";
                    break;
            case "checkbox":
                    newcell.childNodes[0].checked = false;
                    break;
            case "select-one":
                    newcell.childNodes[0].selectedIndex = 0;
                    break;
        }
    }
}
