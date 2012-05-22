<div class="personnel-element-box ui-corner-all">
	<div class="personnel-element-image ui-corner-all" style="background-image:url(img/personnel/[:gender]_[:picture].png)">&nbsp;</div>
	<div class="personnel-element-info-box">
		<div class="personnel-element-info-about">
			<div>Name:&nbsp;<b>[:name]</b></div>
			[:when (requestParams.action_type == "market")]{<div>Price:&nbsp;<b>SK$&nbsp;[:price]</b></div>}
			<div>Salary:&nbsp;<b>SK$&nbsp;[:salary]</b></div>
			<div>Country:&nbsp;<img src="img/flags/[:country_shortname].png" alt="[:country_name]" title="[:country_name]" border="0"></div>
		</div>
		<div class="personnel-element-info-data">
			<div class="personnel-element-info-data-box-container">
				<div class="personnel-element-info-data-box">
					<div class="personnel-element-info-data-name">Repair <span>[:skill_repair]</span> (%)</div>
					<div class="progress-bar-box-small">
						<div class="progress-improve-bar-small" style="width:[:skill_repair]%"></div>
					</div>
				</div>
				<div class="personnel-element-info-data-box">
					<div class="personnel-element-info-data-name">Engineering <span>[:skill_engineering]</span> (%)</div>
					<div class="progress-bar-box-small">
						<div class="progress-improve-bar-small" style="width:[:skill_engineering]%"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="personnel-element-button-box">
		<div class="personnel-element-button-box-container" style="height:[:when ((skill_repair < 90 | skill_engineering < 90) & requestParams.action_type == "own")]{50}[:when (((skill_repair > 89 & skill_engineering > 89) & requestParams.action_type == "own") | requestParams.action_type == "market")]{25}px;">
			[:when (requestParams.action_type == "market")]{<div><a href="#Personnel/hire?personnel_id=[:personnel_id]" class="button personnel-button" module="GARAGE_PERSONNEL_HIRE">hire</a></div>}
			[:when (requestParams.action_type == "own")]{
				[:when (skill_repair < 90 | skill_engineering < 90)]{<div><a href="#Garage/personnel?personnel_instance_id=[:id]" class="button personnel-button" module="GARAGE_PERSONNEL_TRAIN">train</a></div>}
				<div><a href="#Personnel/fire?id=[:personnel_instance_id]" class="button personnel-button confirm-box" module="GARAGE_PERSONNEL_FIRE" title="Fire staff" message="Are you sure you want to fire this staff?">fire</a></div>
			}
		</div>
	</div>
	<div class="crearfix"></div>
</div>
