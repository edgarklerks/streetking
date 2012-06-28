<div class="small-element-container ui-corner-all">
	<div class="small-element-image-container small-element-image-container183">
		<div class="small-element-image-box" style="background-image:url(img/personnel/[:gender]_[:picture].png)">&nbsp;</div>
	</div>
	<div class="small-element-info-container small-element-info-container183">
		<div class="small-element-info-title">
			[:when (report_descriptor == "fire_personnel")]{Fire team member}
			[:when (report_descriptor == "train_personnel")]{Staff participated in training}
			[:when (report_descriptor == "hire_personnel")]{Hired a new team member}
		</div>
		<div class="small-element-info-box">
			<div class="small-element-info-about">
				<div>Name:&nbsp;<b>[:name]</b></div>
				<div>Salary:&nbsp;<b>SK$&nbsp;[:salary]</b></div>
				<div>Country:&nbsp;<img src="img/flags/[:country_shortname].png" alt="[:country_name]" title="[:country_name]" border="0"></div>
				[:when (report_descriptor == "train_personnel")]{
					<div>Improve skill:&nbsp;<b>[:type]</b></div>
				}
			</div>
			<div class="small-element-info-data">
				<div class="small-element-info-data-box-container">
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Repair: <span>[:skill_repair]</span> %</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							[:when (report_descriptor == "train_personnel" & type == "repair")]{<div class="progress-bar-small-progress ui-corner-all-2px" style="width:[:skill_repair]%"></div>}
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:when (result != "success")]{[:eval floor(skill_repair-result)]}[:when (result == "success")]{[:skill_repair]}%"></div>
						</div>
					</div>
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Engineering: <span>[:skill_engineering]</span> %</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							[:when (report_descriptor == "train_personnel" & type == "engineering")]{<div class="progress-bar-small-progress ui-corner-all-2px" style="width:[:skill_engineering]%"></div>}
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:when (result != "success")]{[:eval floor(skill_engineering-result)]}[:when (result == "success")]{[:skill_engineering]}%"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="small-element-info-data"></div>
		</div>
		<div class="small-element-additional-info-box">
			<div>Time:&nbsp;<b class="timestamp">[:time]</b></div>
			[:when (report_descriptor != "fire_personnel")]{
				<div>Cost:&nbsp;<b class="red">SK$ [:cost]</b></div>
			}
			[:when (result != "success")]{
				<div>Abilities increased:&nbsp;<b class="green">+[:result]</b></div>
			}
		</div>
	</div>
	<div class="crearfix"></div>
</div>