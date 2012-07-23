<div class="small-element-container ui-corner-all">
	<div class="small-element-image-container">
		<div class="small-element-image-box" style="background-image:url(img/personnel/[:gender]_[:picture].png)">&nbsp;</div>
	</div>
	<div class="small-element-info-container">
		<div class="small-element-info-box">
			<div class="small-element-info-about">
				<div>Name:&nbsp;<b>[:name]</b></div>
				[:when (requestParams.action_type == "market")]{<div>Price:&nbsp;<b>SK$&nbsp;[:price]</b></div>}
				<div>Salary:&nbsp;<b>SK$&nbsp;[:salary]</b></div>
				<div>Country:&nbsp;<img src="img/flags/[:country_shortname].png" alt="[:country_name]" title="[:country_name]" border="0"></div>
			</div>
			<div class="small-element-info-data">
				<div class="small-element-info-data-box-container">
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Repair: <span>[:skill_repair]</span> %</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:skill_repair]%"></div>
						</div>
					</div>
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Engineering: <span>[:skill_engineering]</span> %</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:skill_engineering]%"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="small-element-button-box">
			[:when (requestParams.action_type == "market")]{<a href="#Personnel/hire?personnel_id=[:personnel_id]" class="button small-button" module="GARAGE_PERSONNEL_HIRE">hire</a>}
			[:when (requestParams.action_type == "own")]{
				<a href="#Personnel/fire?id=[:personnel_instance_id]" class="button small-button confirm-box" module="GARAGE_PERSONNEL_FIRE" title="Fire staff" message="Are you sure you want to fire this staff?">fire</a>
				[:when (skill_repair < 90 | skill_engineering < 90)]{<a href="#Garage/personnel?id=[:personnel_instance_id]" class="button small-button" module="GARAGE_PERSONNEL_TRAIN">train</a>}
			}
		</div>
	</div>
	<div class="crearfix"></div>
</div>