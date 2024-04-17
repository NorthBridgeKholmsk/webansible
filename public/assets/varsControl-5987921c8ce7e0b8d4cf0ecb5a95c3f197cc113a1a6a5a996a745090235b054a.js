function addVar(){
    const btn_addVar = document.getElementById("btn_addVar");
    const newVar = document.getElementById("newVar").cloneNode(true);
    newVar.id = "";
    newVar.classList.remove("visually-hidden");
    document.getElementById("vars").insertBefore(newVar, btn_addVar);
}

function delVar(e){
    e.parentElement.parentElement.remove();
}

function getAllVars(){
    const group_variables = document.getElementById("group_variables");
    var variables = new Map();
    const rowsVar = document.getElementById("vars").getElementsByClassName("row");

    for (var i = 2; i < rowsVar.length; i++){
        var varItem = rowsVar[i].children;
        if (!varItem[0].children[0].value.isEmpty() && !varItem[1].children[0].value.isEmpty()){
            variables.set(varItem[0].children[0].value, varItem[1].children[0].value);
        }
    }

    group_variables.value = JSON.stringify(Object.fromEntries(variables));
};
