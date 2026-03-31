const API = 'http://localhost:3000/api';

function getUser()    { const u=localStorage.getItem('rb_user'); return u?JSON.parse(u):null; }
function requireLogin(){ const u=getUser(); if(!u){window.location.href='login.html';return null;} return u; }
function logout()     { localStorage.removeItem('rb_user'); window.location.href='login.html'; }

function showAlert(id, msg, type='error'){
  const el=document.getElementById(id);
  if(!el)return;
  el.textContent=msg;
  el.className='alert alert-'+type+' show';
  setTimeout(()=>el.className='alert',5000);
}

function formatDate(d){
  if(!d)return '—';
  return new Date(d).toLocaleDateString('en-IN',{day:'2-digit',month:'short',year:'numeric'});
}
function formatTime(t){
  if(!t)return '—';
  if(typeof t==='string'&&t.length<=8)return t.slice(0,5);
  return new Date(t).toLocaleTimeString('en-IN',{hour:'2-digit',minute:'2-digit',hour12:false});
}

const TYPE_COLOR={
  'Rajdhani':'b-red','Shatabdi':'b-blue','Duronto':'b-navy',
  'Vande Bharat':'b-orange','Express':'b-green','Mail':'b-grey',
  'Superfast':'b-amber','Garib Rath':'b-green'
};
function typeBadge(type){ return `<span class="badge ${TYPE_COLOR[type]||'b-grey'}">${type}</span>`; }
function statusBadge(s){
  const m={Confirmed:'b-green',Cancelled:'b-red',Waitlist:'b-amber',Paid:'b-green',Refunded:'b-orange',Pending:'b-amber'};
  return `<span class="badge ${m[s]||'b-grey'}">${s}</span>`;
}

const ALL_DAYS=['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
function daysRow(runs_on){
  return ALL_DAYS.map(d=>`<span class="${runs_on.includes(d)?'day-on':'day-off'}">${d}</span>`).join('');
}

function calcFare(fare_per_km, distance_km){
  return Math.round(fare_per_km * distance_km * 1.05 + 15);
}

function renderNav(active){
  const user=getUser();
  const el=document.getElementById('mainNav');
  if(!el||!user)return;
  const pages=['dashboard','trains','book','mytickets','pnr','profile'];
  const labels={dashboard:'Dashboard',trains:'Trains',book:'Book Ticket',mytickets:'My Tickets',pnr:'PNR Status',profile:'Profile'};
  el.innerHTML=`
    <a href="dashboard.html" class="nav-logo">🚂 Rail<em>Book</em> <span class="logo-tag">PRO</span></a>
    <div class="nav-links">
      ${pages.map(p=>`<a href="${p}.html" class="${active===p?'active':''}">${labels[p]}</a>`).join('')}
    </div>
    <div class="nav-user">
      <div class="nav-avatar">${user.name[0].toUpperCase()}</div>
      <span>${user.name.split(' ')[0]}</span>
      <button class="btn-logout" onclick="logout()">Logout</button>
    </div>`;
}
