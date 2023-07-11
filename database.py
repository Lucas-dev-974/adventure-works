import pyodbc 
import pandas 

server = 'localhost'
database = 'TestAdventureWorks' 
username = 'sa' 
password = 'system#root' 

def HandleHierarchyId(v):
    return str(v)

cnxn = pyodbc.connect('DRIVER={ODBC Driver 18 for SQL Server};SERVER='
                      +server
                      +';DATABASE='
                      +database
                      +';ENCRYPT=yes;UID='
                      +username
                      +';PWD='
                      + password 
                      + ';TrustServerCertificate=Yes')

cnxn.add_output_converter(-151, HandleHierarchyId)
cursor = cnxn.cursor()


def executeSelect(sql):
    cursor.execute(sql)  
    return cursor.fetchall()

class query:
    def humanRessourceEmployeeCount(gender="*"):
        queryWhere = ""

        if(gender == "male" or gender == "m"):
            queryWhere = "WHERE Gender IN ('M')"
        elif (gender == "female" or gender == "f"):
            queryWhere = "WHERE Gender IN ('F')"

        return executeSelect('SELECT COUNT(*) FROM humanresources.employee ' + queryWhere)[0][0]
    
    def PersonCount():
        return executeSelect('SELECT COUNT(*) FROM person.person ')[0][0]
    
    def jobList():
        return executeSelect('''
            SELECT
                DISTINCT jobtitle
            FROM
                humanresources.employee
            ORDER BY
                jobtitle;
        ''')

