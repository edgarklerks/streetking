<form id="edit_form" action="account/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	<input type="hidden" name="password" value="[:0.password]"/>
		
	<div><label>busy_subject_id:</label><input type="text" name="busy_subject_id" value="[:0.busy_subject_id]"/></div>
	<div><label>busy_type:</label><input type="text" name="busy_type" value="[:0.busy_type]"/></div>
	<div><label>busy_until:</label><input type="text" name="busy_until" value="[:0.busy_until]"/></div>
	<div><label>city:</label><input type="text" name="city" value="[:0.city]"/></div>
	<div><label>diamonds:</label><input type="text" name="diamonds" value="[:0.diamonds]"/></div>
	<div><label>email:</label><input type="text" name="email" value="[:0.email]"/></div>
	<div><label>energy:</label><input type="text" name="energy" value="[:0.energy]"/></div>
	<div><label>energy_recovery:</label><input type="text" name="energy_recovery" value="[:0.energy_recovery]"/></div>
	<div><label>energy_updated:</label><input type="text" name="energy_updated" value="[:0.energy_updated]"/></div>
	<div><label>firstname:</label><input type="text" name="firstname" value="[:0.firstname]"/></div>
	<div><label>lastname:</label><input type="text" name="lastname" value="[:0.lastname]"/></div>
	<div><label>level:</label><input type="text" name="level" value="[:0.level]"/></div>
	<div><label>max_energy:</label><input type="text" name="max_energy" value="[:0.max_energy]"/></div>
	<div><label>money:</label><input type="text" name="money" value="[:0.money]"/></div>
	<div><label>nickname:</label><input type="text" name="nickname" value="[:0.nickname]"/></div>
	<div><label>picture_large:</label><input type="text" name="picture_large" value="[:0.picture_large]"/></div>
	<div><label>picture_medium:</label><input type="text" name="picture_medium" value="[:0.picture_medium]"/></div>
	<div><label>picture_small:</label><input type="text" name="picture_small" value="[:0.picture_small]"/></div>
	<div><label>respect:</label><input type="text" name="respect" value="[:0.respect]"/></div>
	<div><label>skill_acceleration:</label><input type="text" name="skill_acceleration" value="[:0.skill_acceleration]"/></div>
	<div><label>skill_braking:</label><input type="text" name="skill_braking" value="[:0.skill_braking]"/></div>
	<div><label>skill_control:</label><input type="text" name="skill_control" value="[:0.skill_control]"/></div>
	<div><label>skill_intelligence:</label><input type="text" name="skill_intelligence" value="[:0.skill_intelligence]"/></div>
	<div><label>skill_reactions:</label><input type="text" name="skill_reactions" value="[:0.skill_reactions]"/></div>
	<div><label>skill_unused:</label><input type="text" name="skill_unused" value="[:0.skill_unused]"/></div>
	
	<input type="button" value="save" id="save" module="SAVE">
</form>