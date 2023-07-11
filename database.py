import pyodbc 
import pandas as pd

server = 'localhost'
database = 'AdventureWorksDW' 
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
    # def humanRessourceEmployeeCount(gender="*"):
    #     queryWhere = ""

    #     if(gender == "male" or gender == "m"):
    #         queryWhere = "WHERE Gender IN ('M')"
    #     elif (gender == "female" or gender == "f"):
    #         queryWhere = "WHERE Gender IN ('F')"

    #     return executeSelect('SELECT COUNT(*) FROM humanresources.employee ' + queryWhere)[0][0]
    
    # def PersonCount():
    #     return executeSelect('SELECT COUNT(*) FROM person.person ')[0][0]
    
    # def jobList():
        # return executeSelect('''
        #     SELECT
        #         DISTINCT jobtitle
        #     FROM
        #         humanresources.employee
        #     ORDER BY
        #         jobtitle;
        # ''')

    def getCAPerYear():
        result = executeSelect(''' 
            SELECT
                SUM(UnitPrice) AS Sales,
                YEAR(OrderDate) as YearOfSale
            FROM
                FactInternetSales
            GROUP BY
                YEAR(OrderDate)
            ORDER by
                YearOfSale
        ''')
        
        normalized = [[item[1], float(item[0])] for item in result]
        print(normalized)
        years = []
        cas = []

        for item in normalized:
            years.append(str(item[0]))
            cas.append(int(item[1]))

        print('years', years)
        print('cas', cas)
        return [years, cas]
        

print(query.getCAPerYear())

# import numpy as np
# print(np.random.randn(20, 3))
