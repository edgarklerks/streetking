<div class="tournament-go-and-race-element-container backgound-darkgray">
	<div class="tournament-go-and-race-element-image-container backgound-blue"><div class="tournament-go-and-race-element-image-container-image " style="background-image:url(images/no_tournament_image.png)">&nbsp;</div></div>
	<div class="tournament-go-and-race-element-vertical-line"></div>
	<div class="tournament-go-and-race-element-data-container">
		<div class="tournament-go-and-race-element-info-container">
			<div class="tournament-go-and-race-element-infotext-container">
				<div>Name:&nbsp;<span>[:name]</span></div>
				[:when (requestParams.action_type == "market")]{<div>Price:&nbsp;<span>SK$&nbsp;[:price]</span></div>}
				<div>Salary:&nbsp;<span>SK$&nbsp;[:salary]</span></div>
				<div>Country:&nbsp;<img src="img/flags/[:country_shortname].png" alt="[:country_name]" title="[:country_name]" border="0"></div>
			</div>
			<div class="tournament-go-and-race-element-infobar-container">
				<div class="tournament-go-and-race-element-info-data-box">
					<div class="tournament-go-and-race-element-info-data-box-name">Repair: <span>[:skill_repair]</span> %</div>
					<div class="tournament-go-and-race-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-go-and-race-element-progress-bar ui-corner-all-1px" style="width:[:skill_repair]%"></div>
					</div>
				</div>
				<div class="tournament-go-and-race-element-info-data-box">
					<div class="tournament-go-and-race-element-info-data-box-name">Engineering: <span>[:skill_engineering]</span> %</div>
					<div class="tournament-go-and-race-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-go-and-race-element-progress-bar ui-corner-all-1px" style="width:[:skill_engineering]%"></div>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="tournament-go-and-race-element-buttons-container">
			[:when (requestParams.action_type == "market")]{<a href="#Personnel/hire?personnel_id=[:personnel_id]" class="button small-button" module="GARAGE_PERSONNEL_HIRE">hire</a>}
			[:when (requestParams.action_type == "own")]{
				<a href="#Personnel/fire?id=[:personnel_instance_id]" class="button small-button confirm-box" module="GARAGE_PERSONNEL_FIRE" title="Fire staff" message="Are you sure you want to fire this staff?">fire</a>
				[:when (skill_repair < 90 | skill_engineering < 90)]{<a href="#Garage/personnel?id=[:personnel_instance_id]" class="button small-button" module="GARAGE_PERSONNEL_TRAIN">train</a>}
			}
		</div>
	</div>
	<div class="clearfix"></div>
</div>


