document.addEventListener("DOMContentLoaded", function(){
   let navs = document.getElementsByClassName("nav");
   for (let i = 0; i < navs.length; i++){
       let navs_item = navs[i].children;
       for (let j = 0; j < navs_item.length; j++){
           navs_item[i].addEventListener("click", function (){
               document.getElementById("page_name").innerText = navs_item[i].innerHTML
           });
       }
   }
});
