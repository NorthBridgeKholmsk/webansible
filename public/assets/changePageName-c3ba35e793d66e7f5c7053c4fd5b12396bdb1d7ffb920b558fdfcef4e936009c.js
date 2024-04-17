window.onload = function(){
   let navs = document.getElementsByClassName("nav");
   for (let i = 0; i < navs.length; i++){
       let navs_item = navs[i].children;
       for (let j = 0; j < navs_item.length; j++){
           navs_item[j].addEventListener("click", function (){
               document.getElementById("page_name").innerText = navs_item[j].innerHTML
           });
       }
   }
};
