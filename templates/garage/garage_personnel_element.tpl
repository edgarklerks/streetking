<div class="personnel-element-container backgound-darkgray">
	<div class="personnel-element-image-container backgound-blue"><div class="personnel-element-image-container-image " style="background-image:url(images/personnel/[:gender]_[:picture].png?t=[:eval TIMESTAMP(id)])">&nbsp;</div></div>
	<div class="personnel-element-data-container">
		<div class="personnel-element-info-container">
			<div class="personnel-element-infotext-container">
				<div>Name:&nbsp;<span>[:name]</span></div>
				[:when (requestParams.action_type == "market")]{<div>Price:&nbsp;<span>SK$&nbsp;[:price]</span></div>}
				<div>Salary:&nbsp;<span>SK$&nbsp;[:salary]</span></div>
				<div>Country:&nbsp;<img src="images/flags/[:country_shortname].png" alt="[:country_name]" title="[:country_name]" border="0"></div>
			</div>
			<div class="personnel-element-vertical-line"></div>
			<div class="personnel-element-infobar-container">
				<div class="personnel-element-info-data-box">
					<div class="personnel-element-info-data-box-name">Repair: <span>[:skill_repair]</span> %</div>
					<div class="personnel-element-progress-bar-box ui-corner-all-1px">
						<div class="personnel-element-progress-bar ui-corner-all-1px" style="width:[:skill_repair]%"></div>
					</div>
				</div>
				<div class="personnel-element-info-data-box">
					<div class="personnel-element-info-data-box-name">Engineering: <span>[:skill_engineering]</span> %</div>
					<div class="personnel-element-progress-bar-box ui-corner-all-1px">
						<div class="personnel-element-progress-bar ui-corner-all-1px" style="width:[:skill_engineering]%"></div>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="personnel-element-buttons-container">
			[:when (requestParams.action_type == "market")]{<a href="#Personnel/hire?personnel_id=[:personnel_id]" class="button small-button" module="GARAGE_PERSONNEL_HIRE">hire</a>}
			[:when (requestParams.action_type == "own")]{
				<a href="#Personnel/fire?id=[:personnel_instance_id]" class="button small-button confirm-box" module="GARAGE_PERSONNEL_FIRE" mtitle="Fire staff" message="Are you sure you want to fire this staff?">fire</a>
				[:when (skill_repair < 90 | skill_engineering < 90)]{<a href="#Garage/personnel?id=[:personnel_instance_id]" class="button small-button" module="GARAGE_PERSONNEL_TRAIN">train</a>}
			}
		</div>
	</div>
	<div class="clearfix"></div>
</div>