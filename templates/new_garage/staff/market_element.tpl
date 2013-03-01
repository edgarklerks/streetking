<div>
	<div>Name:&nbsp;<span>{{=sk.name}}</span></div>
	<div>Salary:&nbsp;<span>SK$&nbsp;{{=sk.salary}}</span></div>
	<div>Price:&nbsp;<span>SK$&nbsp;{{=sk.price}}</span></div>
	<div>Country:&nbsp;<img src="images/flags/{{=sk.country_shortname}}.png" alt="{{=sk.country_name}}" title="{{=sk.country_name}}" border="0"></div>
	
	<div>Repair: <span>{{=sk.skill_repair}}</span> %</div>
	<div>Engineering: <span>{{=sk.skill_engineering}}</span> %</div>

	
	<a href="#Personnel/hire?personnel_id={{=sk.personnel_id}}" class="button small-button" module="GARAGE_STAFF_HIRE">hire</a>
</div>