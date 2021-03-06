<div class="profile-box" mtitle="Profile">
	[:when (skill_unused > 0)]{
		<div class="profile-note">You have not used the <b>[:skill_unused]</b> skill points!!!</div>
	}
	<div class="profile-element">
		<div class="profile-skill-name">Acceleration:</div> 
		<div class="profile-skill-count">[:skill_acceleration]</div>
		<div class="profile-skill-increase">
			[:when (skill_unused > 0)]{<a href="#User/addSkill?skill_acceleration=1" class="button" module="ADD_SKILL">+1</a>}
			[:when (skill_unused > 4)]{<a href="#User/addSkill?skill_acceleration=5" class="button" module="ADD_SKILL">+5</a>}
		</div>
		<div class="profile-skill-description">The ability to accurately switch between gears, clutch work, the maximum vehicle acceleration deployments.</div>
		<div class="clearfix"></div>
	</div>
	<div class="profile-element"> 
		<div class="profile-skill-name">Braking:</div>
		<div class="profile-skill-count">[:skill_braking]</div>
		<div class="profile-skill-increase">
			[:when (skill_unused > 0)]{<a href="#User/addSkill?skill_braking=1" class="button" module="ADD_SKILL">+1</a>}
			[:when (skill_unused > 4)]{<a href="#User/addSkill?skill_braking=5" class="button" module="ADD_SKILL">+5</a>}
		</div>
		<div class="profile-skill-description">The ability to provide for the right moment to start braking and effective use of resources in the car, stop-time reduction.</div>
		<div class="clearfix"></div>
	</div>
	<div class="profile-element"> 
		<div class="profile-skill-name">Control:</div>
		<div class="profile-skill-count">[:skill_control]</div>
		<div class="profile-skill-increase">
			[:when (skill_unused > 0)]{<a href="#User/addSkill?skill_control=1" class="button" module="ADD_SKILL">+1</a>}
			[:when (skill_unused > 4)]{<a href="#User/addSkill?skill_control=5" class="button" module="ADD_SKILL">+5</a>}
		</div>
		<div class="profile-skill-description">The ability to precisely control the car in turns, a turn in the maximum possible speed.</div>
		<div class="clearfix"></div>
	</div>
	<div class="profile-element">
		<div class="profile-skill-name">Intelligence:</div>
		<div class="profile-skill-count">[:skill_intelligence]</div>
		<div class="profile-skill-increase">
			[:when (skill_unused > 0)]{<a href="#User/addSkill?skill_intelligence=1" class="button" module="ADD_SKILL">+1</a>}
			[:when (skill_unused > 4)]{<a href="#User/addSkill?skill_intelligence=5" class="button" module="ADD_SKILL">+5</a>}
		</div>
		<div class="profile-skill-description">The ability to place a maximum start, finish turning maneuver and quickly move to the acceleration.</div>
		<div class="clearfix"></div>
	</div>
	<div class="profile-element">
		<div class="profile-skill-name">Reactions:</div>
		<div class="profile-skill-count">[:skill_reactions]</div>
		<div class="profile-skill-increase">
			[:when (skill_unused > 0)]{<a href="#User/addSkill?skill_reactions=1" class="button" module="ADD_SKILL">+1</a>}
			[:when (skill_unused > 4)]{<a href="#User/addSkill?skill_reactions=5" class="button" module="ADD_SKILL">+5</a>}
		</div>
		<div class="profile-skill-description">Running effective path selection, route with the least time to overcome the loss.</div>
		<div class="clearfix"></div>
	</div>
	<div class="profile-element">&nbsp;</div>
</div>