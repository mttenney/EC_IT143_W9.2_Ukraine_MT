--Questions for the Ukrainian datasets:
--Q1 from Oleksii Reznikov, the Minister of Defense: 
--In comparing enemy losses, we want to know 'What are the total count of daily equipment casualties across columns,
--grouped into one column.  The second column needs to reflect daily personnel casualty counts, and the third, POW counts. 
--Show the date along with the three other columns of data

--Instead of the above, I'm going to adapt a question asked by Adam Hodacsek, which was "How do the casualties compare 
--between the two sides? Since I don't have data on Ukraine's losses, I will be comparing total Russian equipment 
--to Total human casualties, instead.

Use Ukraine
GO

With Equip([As of Day], [Sum of Equipment Casualties of All Types])
AS(
SELECT max(day) AS [As of Day], sum(casualties) AS [Sum of Equipment Casualties across Columns]
FROM (
	SELECT date, day, aircraft, helicopter, tank, APC, field_artillery, MRL, military_auto, fuel_tank, drone, naval_ship, anti_aircraft_warfare, special_equipment, vehicles_and_fuel_tanks, cruise_missiles
	FROM russia_losses_equipment) p
	UNPIVOT(
	Casualties FOR Equip IN
			(aircraft, helicopter, tank, APC, field_artillery, MRL, military_auto, fuel_tank, drone, naval_ship, anti_aircraft_warfare, special_equipment, vehicles_and_fuel_tanks, cruise_missiles)
		) AS unpvt
	),
Persnl([As of Day], [Total Russian Personnel Casualties], [Total Russian Prisoners of War] )
AS (
	SELECT max(day) AS [As of Day], max(personnel) AS [Total Russian Personnel Casualties], max(POW) AS [Total Russian Prisoners of War]
	FROM russia_losses_personnel
)

SELECT COALESCE(equip.[As of Day], persnl.[As of Day]) AS [As of Day], [Sum of Equipment Casualties of All Types], ' ' as [VS.], [Total Russian Personnel Casualties], ' ' AS [AND],  [Total Russian Prisoners of War]
FROM Equip
Full OUTER JOIN Persnl ON Equip.[As of Day]=persnl.[As of Day]


--Q2 from Oksana Zholnovych, the Minister of Social Policy:
--In our effort to provide assistance to those who have fled to neighboring countries as a result of the Russian invasion, 
--and to better understand the patterns of immigration, will you please provide data showing the total number 
--of Ukrainian citizen immigrations per month, organized alphabetically by country?
--Please include the number of Russian POWs captured in those months as well, that we can prepare to address their needs.

--Get March's info

SELECT A.date, A.country, b.[# of Immigrants]
FROM (
	SELECT Max(date) AS Date, country
	FROM UKR_Refugees
	Where date between '2022-03-01' and '2022-03-31' 
	group by country
) A
INNER JOIN 
(Select date, country, individuals AS [# of Immigrants]
FROM UKR_Refugees) AS B ON A.Date = B.date and a.country = b.country
ORDER BY country

--Get April's data

SELECT c.date, c.country, d.[# of Immigrants]
FROM (
	SELECT Max(date) AS Date, country
	FROM UKR_Refugees
	Where date between '2022-04-01' and '2022-04-30' 
	group by country
) c
INNER JOIN 
(Select date, country, individuals AS [# of Immigrants]
FROM UKR_Refugees) AS d ON c.Date = d.date and c.country = d.country
ORDER BY country

--Get May's info.

SELECT e.date, e.country, f.[# of Immigrants]
FROM (
	SELECT Max(date) AS Date, country
	FROM UKR_Refugees
	Where date between '2022-05-01' and '2022-05-31' 
	group by country
) e
INNER JOIN 
(Select date, country, individuals AS [# of Immigrants]
FROM UKR_Refugees) AS f ON e.Date = f.date and e.country = f.country
ORDER BY country

--June's info.

SELECT g.date, g.country, h.[# of Immigrants]
FROM (
	SELECT Max(date) AS Date, country
	FROM UKR_Refugees
	Where date between '2022-06-01' and '2022-06-30' 
	group by country
) g
INNER JOIN 
(Select date, country, individuals AS [# of Immigrants]
FROM UKR_Refugees) AS h ON g.Date = h.date and g.country = h.country
ORDER BY country

--July's info.

SELECT i.date, i.country, j.[# of Immigrants]
FROM (
	SELECT Max(date) AS Date, country
	FROM UKR_Refugees
	Where date between '2022-07-01' and '2022-07-31' 
	group by country
) i
INNER JOIN 
(Select date, country, individuals AS [# of Immigrants]
FROM UKR_Refugees) AS j ON i.Date = j.date and i.country = j.country
ORDER BY country

--August's info.

SELECT A.date, A.country, b.[# of Immigrants]
FROM (
	SELECT Max(date) AS Date, country
	FROM UKR_Refugees
	Where date between '2022-08-01' and '2022-08-31' 
	group by country
) A
INNER JOIN 
(Select date, country, individuals AS [# of Immigrants]
FROM UKR_Refugees) AS B ON A.Date = B.date and a.country = b.country
ORDER BY country

--September's info.

SELECT A.date, A.country, b.[# of Immigrants]
FROM (
	SELECT Max(date) AS Date, country
	FROM UKR_Refugees
	Where date between '2022-09-01' and '2022-09-30' 
	group by country
) A
INNER JOIN 
(Select date, country, individuals AS [# of Immigrants]
FROM UKR_Refugees) AS B ON A.Date = B.date and a.country = b.country
ORDER BY country


--select * from UKR_Refugees
--Q3 from Arsen Avakov, the Minister of Internal Affairs: Will you please show us what kind of numerical relationship
--exists between the cities where the greatest Russian personnel casualties were experienced (which may indicate 
--areas of greatest conflict), and the ultimate country location of our citizens who have fled?
--We need to see a ratio of Russian casualties to Ukrainian immigrants.
--Note: I didn't realize this table did not include location for the casualty tables when I came up with the questions. 
--Instead of trying to do that, I will just gather the numbers of Russian casualties to Ukrainian immigrants.

SELECT * FROM
(
SELECT top 1 date, personnel AS [Total Russian Casualties], ' ' AS [VS.]
FROM russia_losses_personnel
Group by personnel, date
ORDER BY DATE DESC
) r
FULL Outer JOIN
(SELECT top 1 Individuals AS [Total Ukrainian War-time Immigrants]
FROM UKR_Refugees
ORDER BY individuals desc) AS s ON s.[Total Ukrainian War-time Immigrants] = [Total Russian Casualties]


--Q4 from Iryna Vereshchuk, the Minister of Reintegration of Temporarily Occupied Territories: Will you please show us
--which areas of the country have experienced the most devastation, judging by the numbers of Russian equipment
--and combatant casualties on our soil? We need to see the number of Russian casualties per day and how that correlates
--with the location of the greatest equipment losses each day for the months of march and April. Organize by location name.
--Again, I was unaware of missing location info. so for this one, I will just use day data for March & April for both types 
--of casualty data.


SELECT A.DATE, A.DAY, B.PERSONNEL, B.POW, AIRCRAFT, HELICOPTER, TANK, APC, field_artillery AS [FIELD ARTILLERY], 
		MRL, military_auto AS [MILITARY AUTO], fuel_tank AS [FUEL TANK], DRONE, naval_ship AS [NAVAL SHIP], anti_aircraft_warfare AS [ANTI AIRCRAFT WARFARE]
FROM russia_losses_equipment AS A
INNER JOIN
russia_losses_personnel AS B  ON A.DATE = A.DATE AND A.DAY = A.DAY
WHERE A.DATE BETWEEN '2022-03-01' AND '2022-04-30' 