<li>
	<div class="setup-part-element-box ui-corner-all">
		<div class="setup-part-element-info-box-container">
			<div class="setup-part-element-image-container">
				<div class="setup-part-element-image ui-corner-all sk-icon-70x70 sk-icon-70x70-[:name]">&nbsp;
					[:when (improvement > 0)]{<div class="part-element-improvement-image ui-corner-all"></div><div class="part-element-improvement-image-border ui-corner-all"></div>}
					[:when (unique)]{<div class="part-element-unique-image ui-corner-all"></div><div class="part-element-unique-image-border ui-corner-all"></div>}
				</div>
				<div class="setup-part-element-info-about">Level:&nbsp;<b>[:level]</b></div>
			</div>
			<div class="setup-part-element-info-box">
				<div class="setup-part-element-info-data">
					<div class="setup-part-element-info-data-box-container">
						<div class="setup-part-element-info-data-box">
							<div class="setup-part-element-info-data-name">[:parameter1_name] <span>+[:parameter1]</span> ([:parameter1_unit])</div>
							<div class="progress-bar-box-small">
								<div class="progress-bar-small" style="left:-[:eval 100-((parameter1/100)*100)]%"></div>
							</div>
						</div>
						<div class="setup-part-element-info-data-box">
							<div class="setup-part-element-info-data-name">Weight <span>+[:weight]</span> (kg)</div>
							<div class="progress-bar-box-small">
								<div class="progress-bar-small" style="left:-[:eval 100-((weight/100)*100)]%"></div>
							</div>
						</div>
						[:when (unique == false)]{
							<div class="part-element-info-data-box">
								<div class="part-element-info-data-name">Improve <span>[:eval floor(improvement/1000)]</span> (%)</div>
								<div class="progress-bar-box-small">
									<div class="progress-improve-bar-small" style="left:-[:eval 100-((improvement/100000)*100)]%"></div>
								</div>
							</div>
						}
						<div class="part-element-info-data-box">
							<div class="part-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> (%)</div>
							<div class="progress-bar-box-small">
								<div class="progress-wear-bar-small" style="width:[:eval floor(wear/1000)]%"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="crearfix"></div>
		</div>
		<div class="setup-part-element-button-box">
			<div class="setup-part-element-button-box-container">
				<a href="#Garage/addPart?part_instance_id=[:part_instance_id]&car_instance_id=[:requestParams.car_instance_id]" class="button setup-part-button" module="GARAGE_CAR_PART_ADD">add</a>
				[:when (unique == false)]{<a href="#Personnel/task?subject_id=[:part_instance_id]&task=improve_part" class="button setup-part-button cmd-improve" module="GARAGE_CAR_TASK">improve</a>}
				[:when (wear > 0)]{<a href="#Personnel/task?subject_id=[:part_instance_id]&task=repair_part" class="button setup-part-button cmd-repair" module="GARAGE_TASK">repair</a>}
			</div>
		</div>
	</div>
</li>
