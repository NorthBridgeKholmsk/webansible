var selectCount = document.getElementById("count_select");
var rows = document.getElementsByClassName("select_row");

document.addEventListener("DOMContentLoaded", function(){
    for (var i = 0; i < rows.length; i++){
        rows[i].addEventListener("click", checkBoxTable_clickSelectRow)
    }
});

function checkBoxTable_clickSelectAll(){
    const checkBoxAll = document.getElementById("select_all")

    for (var i = 0; i < rows.length; i++){
        rows[i].checked = checkBoxAll.checked;
        toggleCheck(checkBoxAll.checked, rows[i]);
    }

    changeSelectCount();
}

function checkBoxTable_clickSelectRow(e){
    toggleCheck(e.checked, e);
    changeSelectCount();
}

function toggleCheck(condition ,checkbox){
    if (condition){
        checkbox.classList.add("checked");
    }
    else{
        checkbox.classList.remove("checked");
    }
}

function changeSelectCount(){
    document.getElementById("count_select").innerHTML = document.getElementsByClassName("checked").length;

    if (document.getElementsByClassName("checked").length > 0){
        document.getElementById("btn_del").classList.remove("disabled");
    }
    else{
        document.getElementById("btn_del").classList.add("disabled");
    }
};
