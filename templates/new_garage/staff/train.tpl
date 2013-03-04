{{? '0' in sk}}
	<form id="training" name="training" action="Personnel/train" method="POST" mtitle="Training your staff">
		<input type="hidden" name="id" value="{{=sk[0].personnel_instance_id}}"/>
		<div class="training-staff-container">
			<div class="error">&nbsp;</div>
			<div class="training-staff-title-box training-staff-title-box-by-type">
				<div class="training-staff-title-box-name">Training type</div>
				<div class="training-staff-title-box-line">&nbsp;</div>
				<div class="clearfix"></div>
			</div>
			<div class="training-staff-box-fields-box">
				<div class="training-staff-radio-button-box">
					<input type="radio" name="type" price="{{=sk[0].training_cost_repair}}" id="repair_radio" value="repair"{{? sk[0].skill_repair > 89 }} disabled {{?}}>
					<label for="repair_radio" class="{{? sk[0].skill_repair > 89 }} text-disabled {{?}}">
						Train repairs 
						{{? sk[0].skill_repair > 89 }} 
							<span>&nbsp;&nbsp;&nbsp;(You can not train more)</span> 
						{{?}}
					</label>
				</div>
				<div class="clearfix"></div>
				<div class="training-staff-radio-button-box">
					<input type="radio" name="type" price="{{=sk[0].training_cost_engineering}}" id="engineering_radio" value="engineering" {{? sk[0].skill_engineering > 89 }} disabled {{?}}>
					<label for="engineering_radio">
						Train engineering
						{{? sk[0].skill_engineering > 89 }}
							<span>&nbsp;&nbsp;&nbsp;(You can not train more)</span>
						{{?}}
					</label>
				</div>
				<div class="clearfix"></div>
			</div>
			<div class="training-staff-title-box training-staff-title-box-by-type">
				<div class="training-staff-title-box-name">Training level</div>
				<div class="training-staff-title-box-line">&nbsp;</div>
				<div class="clearfix"></div>
			</div>
			<div class="training-staff-box-fields-box">
				<div class="training-staff-radio-button-box"><input type="radio" name="level" factor="1" id="level_low" value="low" checked="checked"><label for="level_low">Low (1-4)%</label></div>
				<div class="clearfix"></div>
				<div class="training-staff-radio-button-box"><input type="radio" name="level" factor="1.5" id="level_medium" value="medium"><label for="level_medium">Medium (3-6)%</label></div>
				<div class="clearfix"></div>
				<div class="training-staff-radio-button-box"><input type="radio" name="level" factor="2" id="level_high" value="high"><label for="level_high">High (5-8)%</label></div>
				<div class="clearfix"></div>
			</div>
			<div class="training-staff-title-box training-staff-title-box-by-cost">
				<div class="training-staff-title-box-name">Training cost</div>
				<div class="training-staff-title-box-line">&nbsp;</div>
				<div class="clearfix"></div>
			</div>
			<div class="training-staff-box-fields-box training-staff-cost" id="training_price">Training price is <b>SK$ <span></span></b></div>
			<div class="buttons-panel">
				<a class="button" id="cmd_training" href="#" module="GARAGE_STAFF_TRAIN_DO">train</a>
			</div>
			<div class="clearfix"></div>
		</div>
	</form>
{{?}}