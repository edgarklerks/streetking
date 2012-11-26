<form id="edit_form" action="personnel_instance/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box-noimage">
			<div><label>deleted:</label>[:eval OPTIONTRUEFALSE("[\"deleted\",\""+0.deleted+"\"]")]</div>
			<div><label>garage_id:</label><input type="text" name="garage_id" list="account_garage" listFillField="garage_id" listShowField="garage_id,nickname" value="[:0.garage_id]"/></div>
			<div><label>paid_until:</label><input type="text" name="paid_until" value="[:0.paid_until]"/></div>
			<div><label>personnel_id:</label><input type="text" name="personnel_id" list="personnel" value="[:0.personnel_id]"/></div>
			<div><label>salary:</label><input type="text" name="salary" value="[:0.salary]"/></div>
			<div><label>skill_engineering:</label><input type="text" name="skill_engineering" value="[:0.skill_engineering]"/></div>
			<div><label>skill_repair:</label><input type="text" name="skill_repair" value="[:0.skill_repair]"/></div>
			<div><label>task_end:</label><input type="text" name="task_end" value="[:0.task_end]"/></div>
			<div><label>task_id:</label><input type="text" name="task_id" value="[:0.task_id]"/></div>
			<div><label>task_started:</label><input type="text" name="task_started" value="[:0.task_started]"/></div>
			<div><label>task_subject_id:</label><input type="text" name="task_subject_id" value="[:0.task_subject_id]"/></div>
			<div><label>task_updated:</label><input type="text" name="task_updated" value="[:0.task_updated]"/></div>
			<div><label>training_cost_engineering:</label><input type="text" name="training_cost_engineering" value="[:0.training_cost_engineering]"/></div>
			<div><label>training_cost_repair:</label><input type="text" name="training_cost_repair" value="[:0.training_cost_repair]"/></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>


