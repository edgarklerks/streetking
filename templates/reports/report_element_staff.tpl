<div class="report-element-box ui-corner-all">
	<div class="report-element-title">
		<b>
			[:when (report_descriptor == "fire_personnel")]{Fire team member}
			[:when (report_descriptor == "train_personnel")]{Staff participated in training}
			[:when (report_descriptor == "hire_personnel")]{Hired a new team member}
		</b>
	</div>
	<div class="report-element-image ui-corner-all" style="background-image:url(img/personnel/[:gender]_[:picture].png)">&nbsp;</div>
	<div class="report-element-info-box">
		<div class="report-element-info-about">
			<div>Name:&nbsp;<b>[:name]</b></div>
			[:when (requestParams.action_type == "market")]{<div>Price:&nbsp;<b>SK$&nbsp;[:price]</b></div>}
			<div>Salary:&nbsp;<b>SK$&nbsp;[:salary]</b></div>
			<div>Country:&nbsp;<img src="img/flags/[:country_shortname].png" alt="[:country_name]" title="[:country_name]" border="0"></div>
			[:when (report_descriptor == "train_personnel")]{
				<div>Improve skill:&nbsp;<b>[:type]</b></div>
			}
		</div>
		<div class="report-element-info-data">
			<div class="report-element-info-data-box-container">
				<div class="report-element-info-data-box">
					<div class="report-element-info-data-name">Repair <span>[:skill_repair]</span> (%)</div>
					<div class="progress-bar-box-small">
						<div class="progress-improve-bar-small" style="width:[:skill_repair]%"></div>
					</div>
				</div>
				<div class="report-element-info-data-box">
					<div class="report-element-info-data-name">Engineering <span>[:skill_engineering]</span> (%)</div>
					<div class="progress-bar-box-small">
						<div class="progress-improve-bar-small" style="width:[:skill_engineering]%"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="report-element-rinfo-box">
		<div class="report-element-rinfo-box-container">
			<div class="report-element-rinfo-data-time timestamp">[:time]</div>
			[:when (report_descriptor != "fire_personnel")]{
				<div class="report-element-rinfo-cost">cost<br><span class="expenditure"><b>SK$ [:cost]</b></span></div>
			}
			[:when (result != "success")]{
				<div class="report-element-rinfo-abilities">Abilities increased<br><span class="green"><b>+[:result]</b></span></div>
			}
		</div>
	</div>
	<div class="crearfix"></div>
</div>
