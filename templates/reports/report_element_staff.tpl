<div class="report-element-container backgound-darkgray">
	<div class="report-element-container-title">
		[:when (report_descriptor == "fire_personnel")]{Fire team member}
		[:when (report_descriptor == "train_personnel")]{Staff participated in training}
		[:when (report_descriptor == "hire_personnel")]{Hired a new team member}
	</div>
	<div class="report-element-container-inner">
		<div class="report-element-image-container-lines backgound-blue"><div class="report-element-image-container-image-inner" style="background-image:url(images/personnel/[:gender]_[:picture].png?t=[:eval TIMESTAMP(id)])">&nbsp;</div></div>
		<div class="report-element-data-container">
			<div class="report-element-info-container">
				<div class="report-element-infotext-container">
					<div>Name:&nbsp;<span>[:name]</span></div>
					<div>Salary:&nbsp;<span>SK$&nbsp;[:salary]</span></div>
					<div>Country:&nbsp;<img src="img/flags/[:country_shortname].png" alt="[:country_name]" title="[:country_name]" border="0"></div>
					[:when (report_descriptor == "train_personnel")]{
						<div>Improve skill:&nbsp;<span>[:type]</span></div>
					}
					[:when (report_descriptor != "fire_personnel")]{
						<div>Cost:&nbsp;<span class="red">SK$ [:cost]</span></div>
					}
					[:when (result != "success")]{
						<div>Abilities increased:&nbsp;<span class="green">+[:result]</span></div>
					}
				</div>
				<div class="report-element-vertical-line"></div>
				<div class="report-element-infobar-container">







					<div class="report-element-info-data-box">
						<div class="report-element-info-data-name">Repair <span>[:skill_repair]</span> %</div>
						<div class="report-element-progress-bar-box ui-corner-all-1px">
							[:when (task == "improve_part")]{<div class="garage-part-element-progress-bar garage-part-element-progress-improve ui-corner-all-1px" style="width:[:eval floor((improvement+improvement_change)/1000)]%"></div>}
							<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval floor(improvement/1000)]%"></div>
						</div>
					</div>
					<div class="report-element-info-data-box">
						<div class="report-element-info-data-name">Engineering <span>[:skill_engineering]</span> %</div>
						<div class="report-element-progress-bar-box ui-corner-all-1px">
							[:when (task == "improve_part")]{<div class="garage-part-element-progress-bar garage-part-element-progress-improve ui-corner-all-1px" style="width:[:eval floor((improvement+improvement_change)/1000)]%"></div>}
							<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval floor(improvement/1000)]%"></div>
						</div>
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
			<div class="report-element-additional-info-box">
				<div>Time:&nbsp;<span>[:eval TIMESTAMPTODATE(time)]</span></div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>

<!--
<div class="small-element-container ui-corner-all">
	<div class="small-element-info-container small-element-info-container183">
		<div class="small-element-info-box">
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
	</div>
	<div class="crearfix"></div>
</div>
-->