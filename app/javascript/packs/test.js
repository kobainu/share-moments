// confirm("ok");

let nav = document.querySelector("#navArea");
let btn = document.querySelector("#toggleBtn");
let mask = document.querySelector("#mask");

btn.addEventListener("click", () => {
  // confirm("ok");
  nav.classList.toggle("open");
  mask.classList.toggle("blackOut");
});

mask.addEventListener("click", () => {
  // confirm("ok");
  nav.classList.toggle("open");
  mask.classList.toggle("blackOut");
});
