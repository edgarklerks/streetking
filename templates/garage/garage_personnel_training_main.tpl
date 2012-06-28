<form id="training" name="training" action="Personnel/train" method="POST" title="Training your staff">
	<input type="hidden" name="id" value="[:0.personnel_instance_id]"/>
	<div class="error">&nbsp;</div>
	<div class="radio-box"><input type="radio" name="type" price="[:0.training_cost_repair]" value="repair"[:when (0.skill_repair > 89)]{ disabled}><label>Train repairs[:when (0.skill_repair > 89)]{<span>&nbsp;(You can not train more)</span>}</label></div>
	<div class="clearfix marginbottom3"></div>
	<div class="radio-box"><input type="radio" name="type" price="[:0.training_cost_engineering]" value="engineering"[:when (0.skill_engineering > 89)]{ disabled}><label>Train engineering[:when (0.skill_engineering > 89)]{<span>&nbsp;(You can not train more)</span>}</label></div>
	<div class="clearfix marginbottom3"></div>
	<fieldset>
		<legend>Training level</legend>
		<div class="radio-box"><input type="radio" name="level" factor="1" value="low" checked="checked"><label>Low</label></div>
		<div class="clearfix marginbottom3"></div>
		<div class="radio-box"><input type="radio" name="level" factor="1.5" value="medium"><label>Medium</label></div>
		<div class="clearfix marginbottom3"></div>
		<div class="radio-box"><input type="radio" name="level" factor="2" value="high"><label>High</label></div>
		<div class="clearfix marginbottom3"></div>
	</fieldset>
	<div id="training_price">Training price <b>SK$ <span></span></b></div>
	<div class="buttons-panel">
		<input type="button" value="cancel" id="cancel">
		<input type="button" value="train" id="cmd_training" module="GARAGE_PERSONNEL_DO_TRAIN">
	</div>
	<div class="clearfix"></div>
</form>
