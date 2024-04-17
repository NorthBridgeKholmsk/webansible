function addVar(){
    const btn_addVar = document.getElementById("btn_addVar").cloneNode();
    const newVar = document.getElementById("newVar");

    document.getElementById("vars").insertBefore(newVar, btn_addVar);
}

function delVar(){

};
