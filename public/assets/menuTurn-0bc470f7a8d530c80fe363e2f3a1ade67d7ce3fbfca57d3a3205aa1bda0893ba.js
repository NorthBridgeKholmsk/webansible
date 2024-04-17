var menuTurnState = true
function menuTurn(){
    if (menuTurnState === true){
        document.getElementById("logo_img").style.display = "none";
    }
    else{
        document.getElementById("logo_img").style.removeProperty("display");
    }
};
