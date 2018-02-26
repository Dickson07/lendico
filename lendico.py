# import pymysql library to deal with mysql database
import pymysql
# import json library to deal with json
import json
# import csv library to deal with csv importation
import csv
# Initializing mysql database object
connection = pymysql.connect(host='localhost', user='root', password='', db='lendico_db', charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)


def read_json(dir_path):
    try:
        with open(dir_path) as json_data:
            data = json.load(json_data)
        # reading json objects into lists
        iban = [i['IBAN'] for i in data]
        bic = [i['BIC'] for i in data]
        investor_id = [i['investorId'] for i in data]
        # inserting objects from json file into the database
        try:
            # reading json file from file path
            with connection.cursor() as cursor:
                for x, y, z in zip(investor_id, iban, bic):
                    sql = "INSERT INTO `bank_data`(`investorid`, `iban`, `bic`) VALUES(%s, %s, %s)"
                    cursor.execute(sql, (x, y, z))
            connection.commit()
        except Exception as e:
            print(str(e))
        finally:
            connection.close()
    except Exception as k:
        print(str(k))


def read_csv(file_path):
    cursor = connection.cursor()
    try:
        csv_data = csv.reader(open(file_path))
        try:
            for row in csv_data:
                query = "INSERT INTO user_data2(investorid,firstName, lastName, gender, street, streetNumber, zip ) VALUES(%s,%s,%s,%s,%s,%s)"
                cursor.execute(query, row)
            connection.commit()
            cursor.close()
        except Exception as b:
            print(str(b))
        finally:
            connection.close()
    except Exception as g:
        print(str(g))


# Define main method that calls other functions

def main():
    dp = 'C:/Users/emmanuel.akpan/Desktop/lendico-coding-master-resultset/task_dataset/bank_data.json'
    cp = 'C:/Users/emmanuel.akpan/Desktop/lendico-coding-master-resultset/task_dataset/user_data.csv'
    read_json(dp)
    read_csv(cp)

# Execute main() function
if __name__ == '__main__':
    main()




