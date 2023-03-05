let nav = document.getElementById("hamburgerMenuArea");
let btn = document.getElementById("hamburgerMenuBtn");
let mask = document.getElementById("mask");

btn.addEventListener("click", () => {
  nav.classList.toggle("open");
});

mask.addEventListener("click", () => {
  nav.classList.toggle("open");
});
