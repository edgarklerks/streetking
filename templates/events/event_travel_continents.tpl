[:when (me.level > (continent_level - 1))]{<area shape="poly" tt="[:continent_name]" name="area_[:continent_id]" map="continent_[:continent_id]" alt="[:continent_name]" title="[:continent_name]" coords="[:continent_data]" href="#City/list/?continent=[:continent_id]" target=""  module="SELECT_CONTINENT" />}
[:when (me.level < continent_level)]{<area shape="poly" tt="[:continent_name]<br><span>will be unlocked as you reach level [:continent_level]</span>" name="area_[:continent_id]" map="continent_[:continent_id]" alt="[:continent_name]" title="[:continent_name]" coords="[:continent_data]" href="#" target="" />}