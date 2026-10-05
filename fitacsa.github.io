from pathlib import Path

html = r'''<!DOCTYPE html>
<html lang="ro">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FitAcasă — Planul tău de antrenament</title>
<style>
*{box-sizing:border-box}
body{margin:0;font-family:Arial,sans-serif;background:#10131a;color:#f4f6f8}
.wrap{max-width:900px;margin:auto;padding:28px 16px}
.hero{padding:28px 0 18px}
h1{font-size:38px;margin:0 0 8px}
h2{margin-top:0}
p{color:#aeb6c2}
.card,.day{background:#181d26;border:1px solid #2b3442;border-radius:18px;padding:20px;margin:16px 0}
form{display:grid;grid-template-columns:1fr 1fr;gap:15px}
label{font-weight:bold;font-size:14px}
input,select,button{width:100%;margin-top:7px;padding:13px;border-radius:11px;border:1px solid #394556;background:#0f131a;color:#fff;font-size:16px}
button{grid-column:1/-1;background:#6d7cff;border:0;font-weight:bold;cursor:pointer}
button:hover{opacity:.9}
.full{grid-column:1/-1}
.exercise{display:flex;justify-content:space-between;gap:15px;padding:12px 0;border-bottom:1px solid #2b3442}
.exercise:last-child{border-bottom:0}
.tag{display:inline-block;padding:5px 10px;border-radius:99px;background:#29334d;color:#dce2ff;font-size:12px}
.notice{font-size:13px}
#error{color:#ff9b9b;margin-top:10px}
#result{display:none}
@media(max-width:650px){form{grid-template-columns:1fr}.full{grid-column:auto}.exercise{flex-direction:column;gap:4px}h1{font-size:30px}}
</style>
</head>
<body>
<div class="wrap">
  <header class="hero">
    <h1>💪 FitAcasă</h1>
    <p>Un plan simplu de antrenament acasă, adaptat nivelului tău.</p>
  </header>

  <section class="card">
    <h2>Profilul tău</h2>
    <form id="profile">
      <label>Vârsta
        <input id="age" type="number" min="10" max="80" required placeholder="Ex. 16">
      </label>
      <label>Nivel
        <select id="level">
          <option value="beginner">Începător</option>
          <option value="intermediate">Intermediar</option>
          <option value="advanced">Avansat</option>
        </select>
      </label>
      <label>Înălțime (cm)
        <input id="height" type="number" min="100" max="230" placeholder="Ex. 175">
      </label>
      <label>Greutate (kg)
        <input id="weight" type="number" min="25" max="250" placeholder="Ex. 68">
      </label>
      <label class="full">Obiectiv
        <select id="goal">
          <option>Forță și condiție fizică</option>
          <option>Mobilitate și condiție fizică</option>
          <option>Forță generală</option>
        </select>
      </label>
      <button type="submit">Generează rutina</button>
    </form>
    <p class="notice">Înălțimea și greutatea sunt opționale. Pentru minori, programul nu urmărește slăbirea sau aspectul corporal.</p>
    <div id="error"></div>
  </section>

  <section id="result"></section>
</div>

<script>
const routines={
beginner:[
["Luni — Piept + triceps",[["Flotări","3 × 8–12"],["Flotări cu mâinile mai depărtate","3 × 8–12"],["Flotări cu mâinile pe marginea patului/biroului","2 × 10–15"],["Plank","3 × 20–30 sec"]],"Pauză: 60–90 sec între serii."],
["Marți — Picioare",[["Genuflexiuni","3 × 12–15"],["Fandări","3 × 8 pe fiecare picior"],["Ridicări pe vârfuri","3 × 15–20"],["Podul fesier","3 × 12–15"],["Plank","2 × 20–30 sec"]],"Pauză: 60–90 sec între serii."],
["Miercuri — Recuperare",[["Mers","20–30 min"],["Mobilitate/stretching ușor","5–10 min"]],"Fără antrenament greu."],
["Joi — Spate + umeri",[["Bird-dog","3 × 8 pe fiecare parte"],["Superman","2 × 8–10"],["Flotări","3 × 8–12"],["Ridicări de brațe în lateral fără greutăți","3 × 12"],["Plank lateral","2 × 15–25 sec pe fiecare parte"]],"Pauză: 60–90 sec între serii."],
["Vineri — Full body",[["Genuflexiuni","3 × 12"],["Flotări","3 × 8–12"],["Fandări","2 × 8/picior"],["Podul fesier","3 × 12"],["Bird-dog","2 × 8/parte"],["Plank","2 × 20–30 sec"]],"Pauză: 60–90 sec între serii."],
["Sâmbătă — Activitate ușoară",[["Plimbare","20–30 min"],["Mobilitate ușoară","5–10 min"]],"Fără efort intens."],
["Duminică — Odihnă",[["Odihnă","—"]],"Recuperare."]
],
intermediate:[
["Luni — Partea superioară",[["Flotări","4 × 10–15"],["Flotări cu mâinile depărtate","3 × 10–15"],["Plank","3 × 30–45 sec"]],"Pauză: 60–90 sec."],
["Marți — Picioare",[["Genuflexiuni","4 × 15"],["Fandări","3 × 10/picior"],["Ridicări pe vârfuri","4 × 20"],["Podul fesier","3 × 15"]],"Pauză: 60–90 sec."],
["Miercuri — Recuperare",[["Mers","25–35 min"],["Mobilitate","10 min"]],"Zi ușoară."],
["Joi — Spate + core",[["Bird-dog","3 × 10/parte"],["Superman","3 × 10"],["Flotări","3 × 10–15"],["Plank lateral","3 × 20–30 sec/parte"]],"Pauză: 60–90 sec."],
["Vineri — Full body",[["Genuflexiuni","4 × 12–15"],["Flotări","4 × 10–15"],["Fandări","3 × 10/picior"],["Podul fesier","3 × 15"],["Plank","3 × 30 sec"]],"Pauză: 60–90 sec."],
["Sâmbătă — Activitate ușoară",[["Plimbare","30 min"],["Mobilitate","10 min"]],"Fără efort intens."],
["Duminică — Odihnă",[["Odihnă","—"]],"Recuperare."]
],
advanced:[
["Luni — Partea superioară",[["Flotări","4 × 12–20"],["Flotări cu mâinile depărtate","4 × 10–15"],["Plank","4 × 40–60 sec"]],"Pauză: 60–90 sec."],
["Marți — Picioare",[["Genuflexiuni","4 × 15–20"],["Fandări","4 × 10/picior"],["Ridicări pe vârfuri","4 × 20"],["Podul fesier","4 × 15–20"]],"Pauză: 60–90 sec."],
["Miercuri — Recuperare",[["Mers","30 min"],["Mobilitate","10–15 min"]],"Zi de recuperare."],
["Joi — Spate + core",[["Bird-dog","4 × 10/parte"],["Superman","3 × 12"],["Flotări","4 × 12–20"],["Plank lateral","3 × 30–45 sec/parte"]],"Pauză: 60–90 sec."],
["Vineri — Full body",[["Genuflexiuni","4 × 15"],["Flotări","4 × 12–20"],["Fandări","3 × 12/picior"],["Podul fesier","4 × 15"],["Plank","3 × 40 sec"]],"Pauză: 60–90 sec."],
["Sâmbătă — Activitate ușoară",[["Plimbare","30–40 min"],["Mobilitate","10 min"]],"Fără efort intens."],
["Duminică — Odihnă",[["Odihnă","—"]],"Recuperare."]
]
};

const form=document.getElementById("profile");
form.addEventListener("submit",e=>{
 e.preventDefault();
 const age=Number(document.getElementById("age").value);
 if(age<10||age>80){document.getElementById("error").textContent="Introdu o vârstă validă.";return;}
 document.getElementById("error").textContent="";
 const level=document.getElementById("level").value;
 const levelName=document.getElementById("level").selectedOptions[0].textContent;
 const h=document.getElementById("height").value;
 const w=document.getElementById("weight").value;
 const goal=document.getElementById("goal").value;
 const days=routines[level];
 document.getElementById("result").innerHTML=
 `<div class="card"><h2>Rutina ta — ${levelName}</h2><p>${age} ani · ${goal}${h?` · ${h} cm`:""}${w?` · ${w} kg`:""}</p></div>`+
 days.map(d=>`<article class="day"><div style="display:flex;justify-content:space-between;gap:10px;align-items:center"><h2>${d[0]}</h2><span class="tag">${levelName}</span></div>${d[1].map
