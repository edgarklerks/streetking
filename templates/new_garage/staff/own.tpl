{{? '0' in sk}}
	<div>Name:&nbsp;<span>{{=sk[0].name}}</span></div>
	<div>Salary:&nbsp;<span>SK$&nbsp;{{=sk[0].salary}}</span></div>
	<div>Country:&nbsp;<img src="images/flags/{{=sk[0].country_shortname}}.png" alt="{{=sk[0].country_name}}" title="{{=sk[0].country_name}}" border="0"></div>
	{{? sk[0].task_name != "idle" }}
		<div>Busy:&nbsp;<span id="busy_till_{{=sk[0].personnel_id}}" class="personnel-timer">00:00:00</span></div>
	{{?}}
	
	<div>Repair: <span>{{=sk[0].skill_repair}}</span> %</div>
	<div>Engineering: <span>{{=sk[0].skill_engineering}}</span> %</div>
	
	<a href="#Personnel/fire?id={{=sk[0].personnel_instance_id}}" class="button small-button confirm-box" module="GARAGE_STAFF_FIRE" mtitle="Fire staff" message="Are you sure you want to fire this staff?">fire</a>
	{{? (sk[0].skill_repair < 90 || sk[0].skill_engineering < 90) }}
		<a href="#Garage/personnel?id={{=sk[0].personnel_instance_id}}" class="button small-button" module="GARAGE_STAFF_TRAIN">train</a>
	{{?}}
	<div class="clearfix"></div>
{{?}}