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
       
        years = []
        cas = []

        for item in normalized:
            years.append(str(item[0]))
            cas.append(int(item[1]))


        return years, cas
        