/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
SELECT name, membercost FROM Facilities where membercost >0


/* Q2: How many facilities do not charge a fee to members? */
SELECT count(name) FROM Facilities where membercost =0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance FROM Facilities where membercost < monthlymaintenance/5


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT * FROM Facilities WHERE facid IN ( 1, 5 )

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT A.facid, B.monthlymaintenance, A.name,

Case 
	WHEN B.monthlymaintenance >100 then 'Expensive'
	WHEN B.monthlymaintenance <=100 then 'Cheap'
		End as Label 
FROM Facilities A JOIN Facilities B on A.facid = B.facid

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT surname, firstname, max(joindate) FROM Members 

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT CONCAT(Members.surname, ' ' ,Members.firstname) as memname, Facilities.name  
	FROM `Bookings` , `Facilities`, `Members` where Bookings.facid = Facilities.facid and Bookings.memid = Members.memid and Facilities.name Like 'Tennis Court%' group by memname



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


SELECT Members.memid, CONCAT(Members.firstname, ' ' , Members.surname) as fullname ,Bookings.slots, Facilities.name, 

Case
	When Bookings.memid = '0' then Facilities.guestcost*Bookings.slots
	When Bookings.memid != '0' then Facilities.membercost*Bookings.slots
	End as totalcost

FROM Bookings, Facilities, Members where Bookings.facid = Facilities.facid and Bookings.starttime like  '2012-09-14%' and Bookings.memid = Members.memid  group by CONCAT(fullname, name, slots) order by totalcost desc 




/* Q9: This time, produce the same result as in Q8, but using a subquery. */



SELECT sub.*
  FROM (

SELECT Members.memid, CONCAT(Members.firstname, ' ' , Members.surname) as fullname ,Bookings.slots, Facilities.name, 
Case
	When Bookings.memid = '0' then Facilities.guestcost*Bookings.slots
	When Bookings.memid != '0' then Facilities.membercost*Bookings.slots
	End as totalcost

FROM Bookings, Facilities, Members where Bookings.facid = Facilities.facid and Bookings.starttime like  '2012-09-14%' and Bookings.memid = Members.memid
       ) sub
 group by CONCAT(sub.fullname, sub.name, sub.slots) order by sub.totalcost desc
 


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
Total Revenue
Select sub.facname, rev FROM(

SELECT  Facilities.name as facname, Members.memid, sum(Bookings.slots) as fslots, Month(max(Bookings.starttime)) as Endmonth,  Month(min(Bookings.starttime)) as Startmonth,

CASE
When Bookings.memid = 0 then sum(Bookings.slots)*Facilities.guestcost
When Bookings.memid !=0 then (Month(max(Bookings.starttime))-Month(min(Bookings.starttime))+1)*Facilities.monthlymaintenance + sum(Bookings.slots)*Facilities.membercost
End as rev
                                                                               
 
	FROM Bookings, Members, Facilities
where Members.memid = Bookings.memid and Facilities.facid = Bookings.facid group by Bookings.facid, Bookings.memid order by fslots desc
)sub group by facname




Less than 1000

Select sub.*

FROM (

SELECT  Facilities.name as facname, Members.memid, sum(Bookings.slots) as fslots, Month(max(Bookings.starttime)) as Endmonth,  Month(min(Bookings.starttime)) as Startmonth,

CASE
When Bookings.memid = 0 then sum(Bookings.slots)*Facilities.guestcost
When Bookings.memid !=0 then (Month(max(Bookings.starttime))-Month(min(Bookings.starttime))+1)*Facilities.monthlymaintenance + sum(Bookings.slots)*Facilities.membercost
End as rev
                                                                               
 
	FROM Bookings, Members, Facilities
where Members.memid = Bookings.memid and Facilities.facid = Bookings.facid group by Bookings.facid order by fslots desc


)sub where rev <1000
