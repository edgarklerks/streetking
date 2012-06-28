<form id="training" name="training" action="Personnel/train" method="POST" title="Training your staff">
	<input type="hidden" name="id" value="[:0.personnel_instance_id]"/>
	<div class="training-staff-container">
		<div class="error">&nbsp;</div>
		<fieldset class="training-staff-type-box">
			<legend>Training type</legend>
			<div class="radio-button-box"><input type="radio" name="type" price="[:0.training_cost_repair]" id="repair_radio" value="repair"[:when (0.skill_repair > 89)]{ disabled}><label for="repair_radio" class="[:when (0.skill_repair > 89)]{text-disabled}">Train repairs[:when (0.skill_repair > 89)]{<span>&nbsp;&nbsp;&nbsp;(You can not train more)</span>}</label></div>
			<div class="clearfix"></div>
			<div class="radio-button-box"><input type="radio" name="type" price="[:0.training_cost_engineering]" id="engineering_radio" value="engineering"[:when (0.skill_engineering > 89)]{ disabled}><label for="engineering_radio">Train engineering[:when (0.skill_engineering > 89)]{<span>&nbsp;&nbsp;&nbsp;(You can not train more)</span>}</label></div>
			<div class="clearfix"></div>
		</fieldset>
		<fieldset class="training-staff-level-box">
			<legend>Training level</legend>
			<div class="radio-button-box"><input type="radio" name="level" factor="1" id="level_low" value="low" checked="checked"><label for="level_low">Low</label></div>
			<div class="clearfix"></div>
			<div class="radio-button-box"><input type="radio" name="level" factor="1.5" id="level_medium" value="medium"><label for="level_medium">Medium</label></div>
			<div class="clearfix"></div>
			<div class="radio-button-box"><input type="radio" name="level" factor="2" id="level_high" value="high"><label for="level_high">High</label></div>
			<div class="clearfix"></div>
		</fieldset>
		<fieldset class="training-staff-cost-box">
			<legend>Training cost</legend>
			<div id="training_price" class="training-staff-cost">Training price is <b>SK$ <span></span></b></div>
		</fieldset>
		<div class="buttons-panel">
			<input type="button" value="cancel" id="cancel">
			<input type="button" value="train" id="cmd_training" module="GARAGE_PERSONNEL_DO_TRAIN">
		</div>
		<div class="clearfix"></div>
	</div>
</form>