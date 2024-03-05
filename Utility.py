from datetime import datetime
import decimal
import json
import dateutil
from robot.api import logger
from jsonpath_ng import jsonpath, parse


class Utility(object):

    def __init__(self):
        pass

    def keyword(self):
        pass

    def FetchErrorsFromRESTAPIResponse(self, responseData):
        """ Verifies that the REST API response does not contain error field """
        jsonpath_expr=parse('$.body.Error')
        matches = jsonpath_expr.find(responseData)
        return matches
    
    def FetchJsonRequestBody(self,jsonfile, jsonID):
        """ This keyword will fetch the request body from the JSON file based on the jsonID  and 
        return it""" 
        with open(jsonfile) as json_file:
            data= json.load(json_file)
            requestBody=data[jsonID]
            logger.info("requestbody--->" + str(requestBody))
            return  requestBody 
    
    def ValidateJsonDataMatchesWithQueryResultData(self, jsonResponseMap, queryResultMap, dbToJSONMap):
        """ This method verifies the data present in the JSON response and the query result are equal  
        Arguments:
        jsonResponseMap:  This is a dictionary variable having key value pair from the response JSON.
        queryResultMap:   This is a dictionary variable having key value pair from the query result.
        dbToJSONMap:      This is a dictionary variable having key value pair where key  is a database column
        name and value is a JSON field ID
        """
        logger.info("DataMap----->" +str(jsonResponseMap))
        logger.info("queryResultMap---->" +str(queryResultMap))   
        for key in queryResultMap:
            print('\ntype' +str(type(queryResultMap[key])))
            if  isinstance(queryResultMap[key],(float,decimal.Decimal)):
                    if round(float(queryResultMap[key]),2) != round(float(jsonResponseMap[dbToJSONMap[key]]),2):
                        print(('\nValue does not match with data base value. - DB Value-->'+str(queryResultMap[key]) +' And expected value-->' +str(jsonResponseMap[dbToJSONMap[key]])))
                        return  False 
                    else:
                        print(('\nValue matches data base value. - DB Value-->'+str(queryResultMap[key]) +' And expected value-->' +str(jsonResponseMap[dbToJSONMap[key]])))
            elif  isinstance(queryResultMap[key],datetime.date):
                    dateFormat='%Y-%m-%d %H:%M:%S'
                    queryValue= datetime.datetime.strftime(queryResultMap[key], dateFormat)
                    d = dateutil.parser.parse(jsonResponseMap[dbToJSONMap[key]])
                    jsonValue = (d.strftime(dateFormat))
                    if queryValue != jsonValue:
                        print(('\nValue does not match data base value. - DB Value-->'+str(queryResultMap[key]) +' And expected value-->' +str(jsonResponseMap[dbToJSONMap[key]])))    
                        return  False    
                    else:
                        print(('\nValue matches data base value. - DB Value-->'+str(queryResultMap[key]) +' And expected value-->' +str(jsonResponseMap[dbToJSONMap[key]])))      
            elif  isinstance(queryResultMap[key],(int,str)):
                    if queryResultMap[key] != jsonResponseMap[dbToJSONMap[key]]:
                        print(('\nValue does not match data base value. - DB Value-->'+str(queryResultMap[key]) +' And expected value-->' +str(jsonResponseMap[dbToJSONMap[key]])))
                        return  False 
                    else:
                        print(('\nJson value matches data base value. - DB Value-->'+str(queryResultMap[key]) +' And expected value-->' +str(jsonResponseMap[dbToJSONMap[key]])))         
        return  True 
    
    