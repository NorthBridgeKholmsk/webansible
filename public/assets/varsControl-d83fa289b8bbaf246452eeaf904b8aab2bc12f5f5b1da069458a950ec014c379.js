function addVar(id){
    if (id) {
        const btn_addVar = document.getElementById("btn_addVar" + id);
        const newVar = document.getElementById("newVar" + id).cloneNode(true);
        newVar.id = "";
        newVar.classList.remove("visually-hidden");
        document.getElementById("vars" + id).insertBefore(newVar, btn_addVar);
    }
}

function delVar(e){
    e.parentElement.parentElement.remove();
}

function getAllVars(id){
    const group_variables = document.getElementById("variables"+id);
    var variables = new Map();
    const rowsVar = document.getElementById("vars"+id).getElementsByClassName("row");

    for (var i = 2; i < rowsVar.length; i++){
        var varItem = rowsVar[i].children;

        if (varItem[0].children[0].value.trim() !== "" && varItem[1].children[0].value.trim() !== ""){
            variables.set(varItem[0].children[0].value.trim(), varItem[1].children[0].value.trim());
        }
    }

    group_variables.value = JSON.stringify(Object.fromEntries(variables));
};
