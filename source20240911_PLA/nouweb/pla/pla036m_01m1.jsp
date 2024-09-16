<%/*
----------------------------------------------------------------------------------
File Name		: pla036m_01m1.jsp
Author			: leon
Description		: PLA036M_審核專班面授開班作業 - 處理邏輯頁面
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		096/08/21	leon    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/modulepageinit.jsp"%>
<%@page import="com.nou.per.dao.*"%>
<%@page import="com.nou.pla.dao.*"%>
<%@page import="com.nou.cou.dao.*"%>
<%@page import="com.nou.reg.dao.*"%>
<%@ page import="com.nou.sys.dao.SYST001DAO" %>

<%!
/** 處理查詢 Grid 資料 */
public void doQuery(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	Connection conn=null;
	try
	{
		Vector result = new Vector();

		int		pageNo		=	Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
		int		pageSize	=	Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));

		conn       =    dbManager.getConnection(AUTCONNECT.mapConnect("COU", session));

		COUT022GATEWAY  cout022  =    new COUT022GATEWAY(dbManager,conn,pageNo,pageSize);

		result =  cout022.getCout022Syst001Syst002Cout002ForUsePLA036M(requestMap, "Q");

		out.println(DataToJson.vtToJson(cout022.getTotalRowCount(), result));

	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}

/** 處理查詢 V3 Grid 資料 */
public void doQueryV3(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		int		pageNo		=	Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
		int		pageSize	=	Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
		Connection	conn		=	dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));
		
		PERT055DAO	PERT055 = new PERT055DAO(dbManager, conn);
		PERT055.setResultColumn("AYEAR,SMS,CRSNO,S_CLASS_TYPE,S_CLASS_NUM,TUT_TIMES,TUT_DATE");
		PERT055.setAYEAR(Utility.dbStr(requestMap.get("AYEAR")));
		PERT055.setSMS(Utility.dbStr(requestMap.get("SMS")));
		PERT055.setCRSNO(Utility.dbStr(requestMap.get("CRSNO")));
		PERT055.setS_CLASS_TYPE(Utility.dbStr(requestMap.get("S_CLASS_TYPE")));
		PERT055.setS_CLASS_NUM(Utility.dbStr(requestMap.get("S_CLASS_NUM")));
		DBResult rs = PERT055.pageQuery(pageNo, pageSize);
		
		out.println(DataToJson.rsToJson ( PERT055.getTotalRowCount(), rs));
	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}


/** 處理新增存檔 */
public void doAdd(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{

}


/** 處理新增存檔 */
public void doAdd3(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));

		PERT055DAO	PERT055	=	new PERT055DAO(dbManager, conn, requestMap, session);
		PERT055.setUPD_MK("1");
		PERT055.insert();
		/** Commit Transaction */
		dbManager.commit();

		out.println(DataToJson.successJson());
	}
	catch (Exception ex)
	{
		/** Rollback Transaction */
		dbManager.rollback();

		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}

/** 修改帶出資料 */
public void doQueryEdit(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	Vector result = new Vector();
	
	Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("PLA", session));
	
	COUT022GATEWAY  cout022  =    new COUT022GATEWAY(dbManager,conn);

	System.out.println(requestMap);
	
	result =  cout022.getCout022Syst001Syst002Cout002ForUsePLA036M(requestMap, "E");

	out.println(DataToJson.vtToJson (result));

	dbManager.close();
}

/** 修改帶出資料 */
public void doQueryEdit3(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	Vector result = new Vector();
	try
	{
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("PLA", session));
		
		PERT055DAO	PERT055	=	new PERT055DAO(dbManager, conn);
		PERT055.setAYEAR(Utility.dbStr(requestMap.get("AYEAR")));
		PERT055.setSMS(Utility.dbStr(requestMap.get("SMS")));
		PERT055.setCRSNO(Utility.dbStr(requestMap.get("CRSNO")));
		PERT055.setS_CLASS_TYPE(Utility.dbStr(requestMap.get("S_CLASS_TYPE")));
		PERT055.setS_CLASS_NUM(Utility.dbStr(requestMap.get("S_CLASS_NUM")));
		PERT055.setTUT_TIMES(Utility.dbStr(requestMap.get("TUT_TIMES")));
		
		DBResult rs = PERT055.query();
		
		out.println(DataToJson.rsToJson ( PERT055.getTotalRowCount(), rs));

	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}

/** 修改存檔 */
public void doModify(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		//for cout022 update insert
		requestMap.put("SECTION",Utility.dbStr(requestMap.get("SECTION_CODE")));
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("PLA", session));
		
		/**如確定編班註記為「否」*/
		if (requestMap.get("OPEN_YN").toString().equals("02"))
		{
			String	condition	=	"AYEAR		=	'" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
									"SMS		=	'" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
									"CRSNO		=	'" + Utility.dbStr(requestMap.get("CRSNO"))+ "' AND " +
									"S_CLASS_TYPE	=	'" + Utility.dbStr(requestMap.get("S_CLASS_TYPE"))+ "' AND " +
									"S_CLASS_NUM	=	'" + Utility.dbStr(requestMap.get("S_CLASS_NUM"))+ "' AND " +
									"ROWSTAMP	=	'" + Utility.dbStr(requestMap.get("ROWSTAMP")) + "' ";
			
			requestMap.put("UPD_MK","2");
			
			if( Utility.checkNull(requestMap.get("INTERVAL_WEEK"), "").equals("") ){
				requestMap.put("INTERVAL_WEEK", "00");
			}	
			
			COUT022DAO	COUT022	=	new COUT022DAO(dbManager, conn, requestMap, session);
			
			if(Utility.checkNull(requestMap.get("CMPS_ASYS_1"), "").equals("on") && Utility.checkNull(requestMap.get("CMPS_ASYS_2"), "").equals("on")) {
	        	requestMap.put("CMPS_ASYS", "0");
	        } else if(Utility.checkNull(requestMap.get("CMPS_ASYS_1"), "").equals("on") && !Utility.checkNull(requestMap.get("CMPS_ASYS_2"), "").equals("on")) {
	        	requestMap.put("CMPS_ASYS", "1");
	        } else if(!Utility.checkNull(requestMap.get("CMPS_ASYS_1"), "").equals("on") && Utility.checkNull(requestMap.get("CMPS_ASYS_2"), "").equals("on")) {
	        	requestMap.put("CMPS_ASYS", "2");
	        }     
			COUT022.setSEGMENT(Utility.checkNull(requestMap.get("SEGMENT_CODE"), ""));
	        COUT022.setCMPS_ASYS(requestMap.get("CMPS_ASYS").toString());
			int	updateCount	=	COUT022.update(condition);

			dbManager.commit();

			if (updateCount == 0)
				out.println(DataToJson.faileJson("此筆資料已被異動過, <br>請重新查詢修改!!"));
			else
				out.println(DataToJson.successJson());
		}
		/**如確定編班註記為「是」*/
		else
		{
			if (requestMap.get("S_CLASS_ID").toString().equals(""))
			{
				int TUT_TIMES 	= 	Integer.parseInt(requestMap.get("TUT_TIMES_P").toString());
				
				String fourCode 	=	requestMap.get("S_CLASS_ABRCODE_CODE").toString() +
									(requestMap.get("S_CLASS_CMPS_CODE").toString()).substring(0,1) +
									requestMap.get("WEEK").toString() +
									requestMap.get("SECTION_CODE").toString();

				String CLASS_CODE = "";

				PLAT012DAO	PLAT012		=	new PLAT012DAO(dbManager, conn);
				//PLAT012.setResultColumn("'" + fourCode + "'||DECODE(NVL(MAX(SUBSTR(CLASS_CODE,6,1)),'X'),'X','A1', SUBSTR('0A'||TO_CHAR(MAX(SUBSTR(CLASS_CODE,5,2))+1), LENGTH('00'||TO_CHAR(MAX(SUBSTR(CLASS_CODE,6,1))+1))-1)) AS CLASS_CODE ");
				PLAT012.setResultColumn("NVL(MAX(SUBSTR(CLASS_CODE,6,1)),'X') AS CLASS_CODE ");
				PLAT012.setWhere
				(
					"1=1 " +
					"AND length(CLASS_CODE) >= 6 " +
					"AND CLASS_CODE LIKE '" + fourCode + "%' " +
					"AND AYEAR = '" + Utility.dbStr(requestMap.get("AYEAR")) + "' " +
					"AND SMS = '" + Utility.dbStr(requestMap.get("SMS")) + "' " +
					"AND CENTER_ABRCODE = '" + Utility.dbStr(requestMap.get("S_CLASS_ABRCODE_CODE")) + "' " +
					"AND CRSNO = '" + Utility.dbStr(requestMap.get("CRSNO")) + "' " 
				);
	 			System.out.println("*****"+PLAT012.getSql());
				DBResult	rs	=	PLAT012.query();
				
				if (rs.next())
				{
					String CLASS_CODE_MAX = rs.getString("CLASS_CODE");
					//空的	
					if( "X".equals(CLASS_CODE_MAX)){						
						CLASS_CODE = "1";
					}else{
						//用16進位 所以超過16筆會有問題
						int num = Integer.parseInt(CLASS_CODE_MAX,16)+1;
						CLASS_CODE = Integer.toHexString(num);
					}
					CLASS_CODE = fourCode+ "A"+CLASS_CODE;
				}
				
				/** 處理新增動作 (PLAT012)*/
				Hashtable htPlat012 = new Hashtable();
				htPlat012.put("AYEAR", Utility.dbStr(requestMap.get("AYEAR")));
				htPlat012.put("SMS", Utility.dbStr(requestMap.get("SMS")));
				htPlat012.put("CLASS_CODE", CLASS_CODE.toUpperCase());
				htPlat012.put("CENTER_ABRCODE", Utility.dbStr(requestMap.get("S_CLASS_ABRCODE_CODE")));
				htPlat012.put("CMPS_CODE", Utility.dbStr(requestMap.get("S_CLASS_CMPS_CODE")));
				htPlat012.put("SWEEK", Utility.dbStr(requestMap.get("WEEK")));
				htPlat012.put("CLASS_KIND", "8");
				htPlat012.put("CRSNO", Utility.dbStr(requestMap.get("CRSNO")));
				htPlat012.put("SEGMENT_CODE", Utility.dbStr(requestMap.get("SEGMENT_CODE")));
				htPlat012.put("SECTION_CODE", Utility.dbStr(requestMap.get("SECTION_CODE")));
				//htPlat012.put("TCH_IDNO", Utility.dbStr(requestMap.get("S_CLASS_TCH_IDNO")));//專班開班因教師暫不知道，故不寫入
				htPlat012.put("CLSSRM_CODE", Utility.dbStr(requestMap.get("S_CLASS_CLASS_CODE")));
				htPlat012.put("CLS_YN", "Y");
				htPlat012.put("UPD_MK", "1");
				
				PLAT012	=	new PLAT012DAO(dbManager, conn, htPlat012, session);
				PLAT012.insert();

				
				
				/** 處理新增動作 (PLAT013)*/
				/** 專班開班因先開班再聘教師，故不寫入
				for (int i=1; i <= TUT_TIMES; i++)
				{				
					Hashtable htPlat013 = new Hashtable();
					htPlat013.put("AYEAR", Utility.dbStr(requestMap.get("AYEAR")));
					htPlat013.put("SMS", Utility.dbStr(requestMap.get("SMS")));
					htPlat013.put("CLASS_CODE", CLASS_CODE);
					htPlat013.put("CENTER_ABRCODE", Utility.dbStr(requestMap.get("S_CLASS_ABRCODE_CODE")));
					htPlat013.put("CMPS_CODE", Utility.dbStr(requestMap.get("S_CLASS_CMPS_CODE")));
					//htPlat013.put("TCH_IDNO", Utility.dbStr(requestMap.get("S_CLASS_TCH_IDNO")));
					htPlat013.put("TUT_ORDER", String.valueOf(i));
					htPlat013.put("UPD_MK", "1");
					
					PLAT013DAO PLAT013	=	new PLAT013DAO(dbManager, conn, htPlat013, session);
					PLAT013.insert();			
				}
				*/
				
				/** 處理修改動作 (COUT022)*/
				String	condition	=	"AYEAR		=	'" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
										"SMS		=	'" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
										"CRSNO		=	'" + Utility.dbStr(requestMap.get("CRSNO"))+ "' AND " +
										"S_CLASS_TYPE	=	'" + Utility.dbStr(requestMap.get("S_CLASS_TYPE"))+ "' AND " +
										"S_CLASS_NUM	=	'" + Utility.dbStr(requestMap.get("S_CLASS_NUM"))+ "' AND " +
										"ROWSTAMP	=	'" + Utility.dbStr(requestMap.get("ROWSTAMP")) + "' ";

				requestMap.put("S_CLASS_ID", CLASS_CODE.toUpperCase());
				requestMap.put("UPD_MK","2");
				
				if( Utility.checkNull(requestMap.get("INTERVAL_WEEK"), "").equals("") ){
					requestMap.put("INTERVAL_WEEK", "00");
				}
				

				COUT022DAO	COUT022	=	new COUT022DAO(dbManager, conn, requestMap, session);
				int	updateCount	=	COUT022.update(condition);
				
				StringBuffer sql = new StringBuffer();
				sql.append("AYEAR = '"+Utility.dbStr(requestMap.get("AYEAR"))+"' ");
				sql.append("AND SMS = '"+Utility.dbStr(requestMap.get("SMS"))+"' ");
				sql.append("AND TUT_CMPS_CODE = '"+Utility.dbStr(requestMap.get("S_CLASS_CMPS_CODE"))+"' ");
				sql.append("AND TUT_CLASS_CODE = '"+CLASS_CODE.toUpperCase()+"' ");
				
				Hashtable ht = new Hashtable();
				ht.put("UNQUAL_TAKE_MK", "N");
				
				//ht.put("MASTER_CLASS_CODE", CLASS_CODE);
				//ht.put("TUT_CLASS_CODE", CLASS_CODE);
				//ht.put("ASS_CLASS_CODE", CLASS_CODE);
				//ht.put("EXAM_CLASSM_CODE", Utility.dbStr(requestMap.get("S_CLASS_CLASS_CODE")));
				
				REGT007DAO 	regt007 = new REGT007DAO(dbManager, conn, ht, session);
				int	updateCount2	=	regt007.update(sql.toString());

				dbManager.commit();

				if (updateCount == 0)
					out.println(DataToJson.faileJson("(COUT022)此筆資料已被異動過, <br>請重新查詢修改!!"));
				else
					out.println(DataToJson.successJson());		
			}
			else
			{
				/** 處理修改動作 (COUT022)*/
				String	condition	=	"AYEAR		=	'" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
										"SMS		=	'" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
										"CRSNO		=	'" + Utility.dbStr(requestMap.get("CRSNO"))+ "' AND " +
										"S_CLASS_TYPE	=	'" + Utility.dbStr(requestMap.get("S_CLASS_TYPE"))+ "' AND " +
										"S_CLASS_NUM	=	'" + Utility.dbStr(requestMap.get("S_CLASS_NUM"))+ "' AND " +
										"ROWSTAMP	=	'" + Utility.dbStr(requestMap.get("ROWSTAMP")) + "' ";

				requestMap.put("UPD_MK","2");
				
				if( Utility.checkNull(requestMap.get("INTERVAL_WEEK"), "").equals("") ){
					requestMap.put("INTERVAL_WEEK", "00");
				}	

				COUT022DAO	COUT022	=	new COUT022DAO(dbManager, conn, requestMap, session);
				int	updateCount	=	COUT022.update(condition);
				
				StringBuffer sql = new StringBuffer();
				sql.append("AYEAR = '"+Utility.dbStr(requestMap.get("AYEAR"))+"' ");
				sql.append("AND SMS = '"+Utility.dbStr(requestMap.get("SMS"))+"' ");
				sql.append("AND TUT_CMPS_CODE = '"+Utility.dbStr(requestMap.get("S_CLASS_CMPS_CODE"))+"' ");
				sql.append("AND TUT_CLASS_CODE = '"+Utility.dbStr(requestMap.get("S_CLASS_ID"))+"' ");
				
				Hashtable ht = new Hashtable();
				ht.put("UNQUAL_TAKE_MK", "N");
				//ht.put("MASTER_CLASS_CODE", Utility.dbStr(requestMap.get("S_CLASS_ID")));
				//ht.put("TUT_CLASS_CODE", Utility.dbStr(requestMap.get("S_CLASS_ID")));
				//ht.put("ASS_CLASS_CODE", Utility.dbStr(requestMap.get("S_CLASS_ID")));
				//ht.put("EXAM_CLASSM_CODE", Utility.dbStr(requestMap.get("S_CLASS_CLASS_CODE")));
				
				REGT007DAO 	regt007 = new REGT007DAO(dbManager, conn, ht, session);
				int	updateCount2	=	regt007.update(sql.toString());

				dbManager.commit();

				if (updateCount == 0)
					out.println(DataToJson.faileJson("(COUT022)此筆資料已被異動過, <br>請重新查詢修改!!"));
				else
					out.println(DataToJson.successJson());				
			}
			
		}
	}
	catch (Exception ex)
	{

		dbManager.rollback();

		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}


/** 修改存檔 */
public void doModify3(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));

		
		int updateCount = 0;
		String condition = 	"AYEAR = '" + Utility.dbStr(requestMap.get("AYEAR")) + "' "+
							"AND SMS = '" + Utility.dbStr(requestMap.get("SMS")) + "' "+ 
							"AND CRSNO = '" + Utility.dbStr(requestMap.get("CRSNO")) + "' "+
							"AND S_CLASS_NUM = '" + Utility.dbStr(requestMap.get("S_CLASS_NUM")) + "' "+
							"AND S_CLASS_TYPE = '" + Utility.dbStr(requestMap.get("S_CLASS_TYPE")) + "' ";

		/** 處理修改動作 */
		PERT055DAO	PERT055	=	new PERT055DAO(dbManager, conn, requestMap, session);
		PERT055.setUPD_MK("2");
		updateCount	=	PERT055.update(condition);

		/** Commit Transaction */
		dbManager.commit();

		if (updateCount == 0)
			out.println(DataToJson.faileJson("此筆資料已被異動過, <br>請重新查詢修改!!"));
		else
			out.println(DataToJson.successJson());
	}
	catch (Exception ex)
	{
		/** Rollback Transaction */
		dbManager.rollback();

		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}

/** 刪除資料 */
public void doDelete(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection	conn		=	dbManager.getConnection(AUTCONNECT.mapConnect("PLA", session));


		StringBuffer	conditionBuff	=	new StringBuffer();

		String[]	AYEAR		=	Utility.split(requestMap.get("AYEAR").toString(), ",");
		String[]	SMS		=	Utility.split(requestMap.get("SMS").toString(), ",");
		String[]	S_CLASS_ABRCODE_CODE 		=	Utility.split(requestMap.get("S_CLASS_ABRCODE_CODE").toString(), ",");
		String[]	S_CLASS_CMPS_CODE		=	Utility.split(requestMap.get("S_CLASS_CMPS_CODE").toString(), ",");
		String[]	CRSNO		=	Utility.split(requestMap.get("CRSNO").toString(), ",");
		String[]	S_CLASS_TYPE	=	Utility.split(requestMap.get("S_CLASS_TYPE").toString(), ",");
		String[]	S_CLASS_NUM	=	Utility.split(requestMap.get("S_CLASS_NUM").toString(), ",");

		for (int i = 0; i < AYEAR.length; i++)
		{
			if (i > 0)
				conditionBuff.append (" OR ");

			conditionBuff.append
			(
				"(" +
				"	AYEAR		=	'" + Utility.dbStr(AYEAR[i])+ "' AND " +
				"	SMS		=	'" + Utility.dbStr(SMS[i])+ "' AND " +
				"	S_CLASS_ABRCODE_CODE		=	'" + Utility.dbStr(S_CLASS_ABRCODE_CODE[i])+ "' AND " +
				"	S_CLASS_CMPS_CODE		=	'" + Utility.dbStr(S_CLASS_CMPS_CODE[i])+ "' AND " +				
				"	CRSNO		=	'" + Utility.dbStr(CRSNO[i])+ "' AND " +
				"	S_CLASS_TYPE	=	'" + Utility.dbStr(S_CLASS_TYPE[i])+ "' AND " +
				"	S_CLASS_NUM	=	'" + Utility.dbStr(S_CLASS_NUM[i])+ "' " +
				")"
			);
		}


		COUT022DAO	COUT022	=	new COUT022DAO(dbManager, conn, requestMap, session);
		COUT022.delete(conditionBuff.toString());


		dbManager.commit();

		out.println(DataToJson.successJson());
	}
	catch (Exception ex)
	{

		dbManager.rollback();

		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}


/** 刪除資料 */
public void doDelete3(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection	conn		=	dbManager.getConnection(AUTCONNECT.mapConnect("PLA", session));


		StringBuffer	conditionBuff	=	new StringBuffer();

		String[]	AYEAR			=	Utility.split(requestMap.get("AYEAR").toString(), ",");
		String[]	SMS				=	Utility.split(requestMap.get("SMS").toString(), ",");
		String[]	CRSNO			=	Utility.split(requestMap.get("CRSNO").toString(), ",");
		String[]	S_CLASS_TYPE	=	Utility.split(requestMap.get("S_CLASS_TYPE").toString(), ",");
		String[]	S_CLASS_NUM		=	Utility.split(requestMap.get("S_CLASS_NUM").toString(), ",");
		String[]	TUT_TIMES		=	Utility.split(requestMap.get("TUT_TIMES").toString(), ",");

		for (int i = 0; i < AYEAR.length; i++)
		{
			if (i > 0)
				conditionBuff.append (" OR ");

			conditionBuff.append
			(
				"(" +
				"	AYEAR		=	'" + Utility.dbStr(AYEAR[i])+ "' AND " +
				"	SMS		=	'" + Utility.dbStr(SMS[i])+ "' AND " +
				"	CRSNO		=	'" + Utility.dbStr(CRSNO[i])+ "' AND " +
				"	S_CLASS_TYPE	=	'" + Utility.dbStr(S_CLASS_TYPE[i])+ "' AND " +
				"	S_CLASS_NUM	=	'" + Utility.dbStr(S_CLASS_NUM[i])+ "' AND " +
				"	TUT_TIMES	=	'" + Utility.dbStr(TUT_TIMES[i])+ "' " +
				")"
			);
		}


		PERT055DAO	PERT055	=	new PERT055DAO(dbManager, conn, requestMap, session);
		PERT055.delete(conditionBuff.toString());


		dbManager.commit();

		out.println(DataToJson.successJson());
	}
	catch (Exception ex)
	{

		dbManager.rollback();

		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}

public void doCancel(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection	conn		=	dbManager.getConnection(AUTCONNECT.mapConnect("PLA", session));


		StringBuffer	conditionBuff	=	new StringBuffer();

		conditionBuff.append
		(
			"AYEAR		=	'" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
			"SMS		=	'" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
			"CENTER_ABRCODE		=	'" + Utility.dbStr(requestMap.get("S_CLASS_ABRCODE_CODE"))+ "' AND " +
			"CMPS_CODE	=	'" + Utility.dbStr(requestMap.get("S_CLASS_CMPS_CODE"))+ "' AND " +
			"CRSNO	=	'" + Utility.dbStr(requestMap.get("CRSNO"))+ "' AND " +
			"CLASS_CODE	=	'" + Utility.dbStr(requestMap.get("S_CLASS_ID"))+ "' "
		);

		PLAT012DAO	PLAT012	=	new PLAT012DAO(dbManager, conn, requestMap, session);
		PLAT012.delete(conditionBuff.toString());		


		/**UPDATE COUT022*/
		String	condition	=	"AYEAR		=	'" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
								"SMS		=	'" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
								"S_CLASS_ABRCODE_CODE		=	'" + Utility.dbStr(requestMap.get("S_CLASS_ABRCODE_CODE"))+ "' AND " +
								"S_CLASS_CMPS_CODE		=	'" + Utility.dbStr(requestMap.get("S_CLASS_CMPS_CODE"))+ "' AND " +
								"CRSNO		=	'" + Utility.dbStr(requestMap.get("CRSNO"))+ "' AND " +
								"S_CLASS_TYPE	=	'" + Utility.dbStr(requestMap.get("S_CLASS_TYPE"))+ "' AND " +
								"S_CLASS_NUM	=	'" + Utility.dbStr(requestMap.get("S_CLASS_NUM"))+ "' AND " +
								"ROWSTAMP	=	'" + Utility.dbStr(requestMap.get("ROWSTAMP")) + "' ";

		Hashtable ht = new Hashtable();
		ht.put("OPEN_YN","02");
		ht.put("S_CLASS_ID","");
		ht.put("UPD_MK","2");

		COUT022DAO	COUT022	=	new COUT022DAO(dbManager, conn, ht, session);
		int	updateCount	=	COUT022.update(condition);
		
		//因專班取消開班原因多，不再適於此作業註記〝學生無效選課〞 108上Maggie,由中心將學生取消該科班選取
		/**
		StringBuffer sql = new StringBuffer();
		sql.append("AYEAR = '"+Utility.dbStr(requestMap.get("AYEAR"))+"' ");
		sql.append("AND SMS = '"+Utility.dbStr(requestMap.get("SMS"))+"' ");
		sql.append("AND substr(MASTER_CLASS_CODE,1,1) = '"+Utility.dbStr(requestMap.get("S_CLASS_ABRCODE_CODE"))+"' ");
		sql.append("AND TUT_CMPS_CODE = '"+Utility.dbStr(requestMap.get("S_CLASS_CMPS_CODE"))+"' ");
		sql.append("AND CRSNO = '"+Utility.dbStr(requestMap.get("CRSNO"))+"' ");
		sql.append("AND MASTER_CLASS_CODE = '"+Utility.dbStr(requestMap.get("S_CLASS_ID"))+"' ");
				
		Hashtable hts = new Hashtable();
		hts.put("UNQUAL_TAKE_MK", "Y"); 
				
		REGT007DAO 	regt007 = new REGT007DAO(dbManager, conn, hts, session);
		int	updateCount2	=	regt007.update(sql.toString());
		*/
		
		dbManager.commit();

		if (updateCount == 0)
			out.println(DataToJson.faileJson("(COUT022)此筆資料已被異動過, <br>請重新查詢修改!!"));
		else
			out.println(DataToJson.successJson());
	}
	catch (Exception ex)
	{

		dbManager.rollback();

		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}

//取得中心簡碼
public void getAbrcode(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection conn = dbManager.getConnection(AUTCONNECT.mapConnect("PLA", session));
		Hashtable ht = new Hashtable();
		String deps = (String) requestMap.get("CENTER_CODE");
		Vector vt = new Vector();
		if(deps != null && !"".equals(deps) && !"null".equals(deps)){
			PLAT001GATEWAY plat001 = new PLAT001GATEWAY(dbManager, conn);
			ht.put("CENTER_ABRCODE", plat001.getAbrCode(deps));
		}
		vt.add(ht);
		out.println(DataToJson.vtToJson(vt));
	}
	catch (Exception ex)
	{
		/** Rollback Transaction */
		dbManager.rollback();

		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}


/** 修改存檔 */
public void doCopy3(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));

		
		int updateCount = 0;
		
		PERT055DAO	PERT055 = new PERT055DAO(dbManager, conn);
		PERT055.setResultColumn("AYEAR,SMS,CRSNO,S_CLASS_TYPE,S_CLASS_NUM,TUT_TIMES,TUT_DATE");
		PERT055.setAYEAR(Utility.dbStr(requestMap.get("C_AYEAR")));
		PERT055.setSMS(Utility.dbStr(requestMap.get("C_SMS")));
		PERT055.setCRSNO(Utility.dbStr(requestMap.get("C_CRSNO")));
		//PERT055.setS_CLASS_TYPE(Utility.dbStr(requestMap.get("S_CLASS_TYPE")));
		PERT055.setS_CLASS_NUM(Utility.dbStr(requestMap.get("C_S_CLASS_NUM")));
		DBResult rs = PERT055.query();
		while (rs.next()) {
			PERT055DAO	PERT055INS	=	new PERT055DAO(dbManager, conn, (String)session.getAttribute("USER_ID"));
			PERT055INS.setAYEAR(Utility.dbStr(requestMap.get("AYEAR")));
			PERT055INS.setSMS(Utility.dbStr(requestMap.get("SMS")));
			PERT055INS.setCRSNO(Utility.dbStr(requestMap.get("CRSNO")));
			PERT055INS.setS_CLASS_NUM(Utility.dbStr(requestMap.get("S_CLASS_NUM")));
			PERT055INS.setS_CLASS_TYPE(rs.getString("S_CLASS_TYPE"));
			PERT055INS.setTUT_TIMES(rs.getString("TUT_TIMES"));
			PERT055INS.setTUT_DATE(rs.getString("TUT_DATE"));
			PERT055INS.setUPD_MK("1");
			PERT055INS.insert();
        }
		
		
		/** 處理修改動作 */
		

		/** Commit Transaction */
		dbManager.commit();
		out.println(DataToJson.successJson());
	}
	catch (Exception ex)
	{
		/** Rollback Transaction */
		dbManager.rollback();

		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}

	/** 多筆改開班 */
	public void doOpen(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
	{
		try
		{
			Connection	conn		=	dbManager.getConnection(AUTCONNECT.mapConnect("PLA", session));
			StringBuffer	conditionBuff	=	new StringBuffer();

			String[]	AYEAR		=	Utility.split(requestMap.get("AYEAR").toString(), ",");
			String[]	SMS		=	Utility.split(requestMap.get("SMS").toString(), ",");
			String[]	CRSNO		=	Utility.split(requestMap.get("CRSNO").toString(), ",");
			String[]	S_CLASS_TYPE	=	Utility.split(requestMap.get("S_CLASS_TYPE").toString(), ",");
			String[]	S_CLASS_NUM	=	Utility.split(requestMap.get("S_CLASS_NUM").toString(), ",");
			String[]	OPEN_YN = Utility.split(requestMap.get("OPEN_YN").toString(), ",");

			String[]	S_CLASS_ID = Utility.split(requestMap.get("S_CLASS_ID").toString(), ",");
			String[]	TUT_TIMES_P = Utility.split(requestMap.get("TUT_TIMES_P").toString(), ",");
			String[]	S_CLASS_ABRCODE_CODE = Utility.split(requestMap.get("S_CLASS_ABRCODE_CODE").toString(), ",");
			String[]	S_CLASS_CMPS_CODE = Utility.split(requestMap.get("S_CLASS_CMPS_CODE").toString(), ",");
			String[]	WEEK = Utility.split(requestMap.get("WEEK").toString(), ",");
			String[]	SECTION_CODE = Utility.split(requestMap.get("SECTION_CODE").toString(), ",");
			String[]	SEGMENT_CODE = Utility.split(requestMap.get("SEGMENT_CODE").toString(), ",");
			String[]	S_CLASS_CLASS_CODE = Utility.split(requestMap.get("S_CLASS_CLASS_CODE").toString(), ",");
			String[]	INTERVAL_WEEK = Utility.split(requestMap.get("INTERVAL_WEEK").toString(), ",");
			
			//OPEN_TYPE 01表示開班 02表示關閉
			String OPEN_TYPE = Utility.checkNull(requestMap.get("OPEN_TYPE"), "");
			
			int	updateCount = 0;
			if("01".equals(OPEN_TYPE)) {
				for (int i = 0; i < AYEAR.length; i++) {
					
					if (("n").equals(S_CLASS_ID[i])) {
						int TUT_TIMES 	= 	Integer.parseInt(TUT_TIMES_P[i]);
						
						String fourCode 	=	S_CLASS_ABRCODE_CODE[i].toString() +
								S_CLASS_CMPS_CODE[i].toString().substring(0,1) +
								WEEK[i].toString() +
								SECTION_CODE[i].toString();

						String CLASS_CODE = "";
						
						PLAT012DAO	PLAT012		=	new PLAT012DAO(dbManager, conn);
						PLAT012.setResultColumn("NVL(MAX(SUBSTR(CLASS_CODE,6,1)),'X') AS CLASS_CODE ");
						
						PLAT012.setWhere
						(
							"1=1 " +
							"AND length(CLASS_CODE) >= 6 " +
							"AND CLASS_CODE LIKE '" + fourCode + "%' " +
							"AND AYEAR = '" + AYEAR[i] + "' " +
							"AND SMS = '" + SMS[i] + "' " +
							"AND CENTER_ABRCODE = '" + S_CLASS_ABRCODE_CODE[i] + "' " +
							"AND CRSNO = '" + CRSNO[i] + "' " 
						);
						
						System.out.println("*****"+PLAT012.getSql());
						
						DBResult	rs	=	PLAT012.query();
						
						if (rs.next())
						{
							String CLASS_CODE_MAX = rs.getString("CLASS_CODE");
							//空的	
							if( "X".equals(CLASS_CODE_MAX)){						
								CLASS_CODE = "1";
							}else{
								//用16進位 所以超過16筆會有問題
								int num = Integer.parseInt(CLASS_CODE_MAX,16)+1;
								CLASS_CODE = Integer.toHexString(num);
							}
							CLASS_CODE = fourCode+ "A"+CLASS_CODE;
						}
						
						S_CLASS_ID[i] = CLASS_CODE;

						/** 處理新增動作 (PLAT012)*/
						Hashtable htPlat012 = new Hashtable();
						htPlat012.put("AYEAR", AYEAR[i]);
						htPlat012.put("SMS", SMS[i]);
						htPlat012.put("CLASS_CODE", CLASS_CODE.toUpperCase());
						htPlat012.put("CENTER_ABRCODE", S_CLASS_ABRCODE_CODE[i]);
						htPlat012.put("CMPS_CODE", S_CLASS_CMPS_CODE[i]);
						htPlat012.put("SWEEK", WEEK[i]);
						htPlat012.put("CLASS_KIND", "8");
						htPlat012.put("CRSNO", CRSNO[i]);
						htPlat012.put("SEGMENT_CODE", SEGMENT_CODE[i]);
						htPlat012.put("SECTION_CODE", SECTION_CODE[i]);
						htPlat012.put("CLSSRM_CODE", S_CLASS_CLASS_CODE[i]);
						htPlat012.put("CLS_YN", "Y");
						htPlat012.put("UPD_MK", "1");

						PLAT012	=	new PLAT012DAO(dbManager, conn, htPlat012, session);
						try {
							PLAT012.insert();
						} catch (Exception e){
							e.printStackTrace();
						}
												
						/** 處理修改動作 (COUT022)*/
						String	condition	=	"AYEAR		=	'" + AYEAR[i] + "' AND " +
												"SMS		=	'" + SMS[i] + "' AND " +
												"CRSNO		=	'" + CRSNO[i] + "' AND " +
												"S_CLASS_TYPE	=	'" + S_CLASS_TYPE[i] + "' AND " +
												"S_CLASS_NUM	=	'" + S_CLASS_NUM[i] + "' " ;
						
						Hashtable requestMap2 = new Hashtable();
						
						requestMap2.put("AYEAR",AYEAR[i]);
						requestMap2.put("INTERVAL_WEEK",INTERVAL_WEEK[i]);
						requestMap2.put("OPEN_YN", "01");
						requestMap2.put("SMS", SMS[i]);
						requestMap2.put("CRSNO", CRSNO[i]);
						requestMap2.put("S_CLASS_ABRCODE_CODE", S_CLASS_ABRCODE_CODE[i]);
						requestMap2.put("S_CLASS_CLASS_CODE", S_CLASS_CLASS_CODE[i]);
						requestMap2.put("S_CALSS_CMPS_CODE", S_CLASS_CMPS_CODE[i]);
						requestMap2.put("S_CLASS_ID", S_CLASS_ID[i].toUpperCase());
						requestMap2.put("S_CLASS_NUM", S_CLASS_NUM[i]);
						requestMap2.put("S_CLASS_TYPE", S_CLASS_TYPE[i]);
						requestMap2.put("TUT_TIMES_P", TUT_TIMES_P[i]);
						requestMap2.put("UPD_MK","2");
						requestMap2.put("WEEK", WEEK[i]);
						
						
						if( Utility.checkNull(INTERVAL_WEEK[i], "").equals("") ){
							requestMap2.put("INTERVAL_WEEK", "00");
						}
						
						COUT022DAO	COUT022	=	new COUT022DAO(dbManager, conn, requestMap2, session);
						updateCount	=	COUT022.update(condition);
						
						StringBuffer sql = new StringBuffer();
						sql.append("AYEAR = '"+ AYEAR[i] +"' ");
						sql.append("AND SMS = '"+ SMS[i] +"' ");
						sql.append("AND TUT_CMPS_CODE = '"+ S_CLASS_CMPS_CODE[i] +"' ");
						sql.append("AND CRSNO = '"+ CRSNO[i] +"' ")
						/** 113PLA0005 更改為考試面授班級之學生為無效選課 */;
						//sql.append("AND MASTER_CLASS_CODE = '"+ CLASS_CODE.toUpperCase() +"' ");
						sql.append("AND TUT_CLASS_CODE = '"+ CLASS_CODE.toUpperCase() +"' ");
						Hashtable ht = new Hashtable();
						ht.put("UNQUAL_TAKE_MK", "N");
						
						REGT007DAO 	regt007 = new REGT007DAO(dbManager, conn, ht, session);
						int	updateCount2	=	regt007.update(sql.toString());
						
					} else {
						/** 處理修改動作 (COUT022)*/
						String	condition	=	"AYEAR		=	'" + AYEAR[i] + "' AND " +
												"SMS		=	'" + SMS[i] + "' AND " +
												"CRSNO		=	'" + CRSNO[i] + "' AND " +
												"S_CLASS_TYPE	=	'" + S_CLASS_TYPE[i] + "' AND " +
												"S_CLASS_NUM	=	'" + S_CLASS_NUM[i] + "' " ;
						
						requestMap.put("UPD_MK","2");
						
						if( Utility.checkNull(INTERVAL_WEEK[i], "").equals("") ){
							requestMap.put("INTERVAL_WEEK", "00");
						}
						
						COUT022DAO	COUT022	=	new COUT022DAO(dbManager, conn, requestMap, session);
						updateCount	=	COUT022.update(condition);
						
						StringBuffer sql = new StringBuffer();
						sql.append("AYEAR = '"+ AYEAR[i] +"' ");
						sql.append("AND SMS = '"+ SMS[i] +"' ");
						sql.append("AND TUT_CMPS_CODE = '"+ S_CLASS_CMPS_CODE[i] +"' ");
						sql.append("AND CRSNO = '"+ CRSNO[i] +"' ");
						sql.append("AND TUT_CLASS_CODE = '"+ S_CLASS_ID[i].toUpperCase() +"' ");
						
						Hashtable ht = new Hashtable();
						ht.put("UNQUAL_TAKE_MK", "N");
						
						REGT007DAO 	regt007 = new REGT007DAO(dbManager, conn, ht, session);
						int	updateCount2	=	regt007.update(sql.toString());
						
					}
				}
				
			} else if ("02".equals(OPEN_TYPE)) {
				for (int i = 0; i < AYEAR.length; i++) {
					conditionBuff = new StringBuffer();
					conditionBuff.append
					(
						"AYEAR		=	'" + AYEAR[i] + "' AND " +
						"SMS		=	'" + SMS[i] + "' AND " +
						"CENTER_ABRCODE		=	'" + S_CLASS_ABRCODE_CODE[i] + "' AND " +
						"CMPS_CODE	=	'" + S_CLASS_CMPS_CODE[i] + "' AND " +
						"CRSNO	=	'" + CRSNO[i] + "' AND " +
						"CLASS_CODE	=	'" + S_CLASS_ID[i] + "' "
					);
					
					Hashtable requestMap2 = new Hashtable();
					requestMap2.put("AYEAR", AYEAR[i]);
					requestMap2.put("SMS", SMS[i]);
					requestMap2.put("CENTER_ABRCODE", S_CLASS_ABRCODE_CODE[i]);
					requestMap2.put("CMPS_CODE", S_CLASS_CMPS_CODE[i]);
					requestMap2.put("CRSNO", CRSNO[i]);
					requestMap2.put("CLASS_CODE", S_CLASS_ID[i]);
					
					//專班開班無須寫入plat013 maggie20191210,其僅判斷同一時段老師是否同時段，現因有不同週次之判斷故不再適用
					//PLAT013DAO	PLAT013	=	new PLAT013DAO(dbManager, conn, requestMap2, session);
					//PLAT013.delete(conditionBuff.toString());
					
					PLAT012DAO	PLAT012	=	new PLAT012DAO(dbManager, conn, requestMap2, session);
					PLAT012.delete(conditionBuff.toString());		


					/**UPDATE COUT022*/
					String	condition	=	"AYEAR		=	'" + AYEAR[i] + "' AND " +
											"SMS		=	'" + SMS[i] + "' AND " +
											"S_CLASS_ABRCODE_CODE		=	'" + S_CLASS_ABRCODE_CODE[i] + "' AND " +
											"S_CLASS_CMPS_CODE		=	'" + S_CLASS_CMPS_CODE[i] + "' AND " +
											"CRSNO		=	'" + CRSNO[i] + "' AND " +
											"S_CLASS_TYPE	=	'" + S_CLASS_TYPE[i] + "' AND " +
											"S_CLASS_NUM	=	'" + S_CLASS_NUM[i] + "' " ;

					Hashtable ht = new Hashtable();
					ht.put("OPEN_YN","02");
					ht.put("S_CLASS_ID","");
					ht.put("UPD_MK","2");

					COUT022DAO	COUT022	=	new COUT022DAO(dbManager, conn, ht, session);
					updateCount	=	COUT022.update(condition);
					
					StringBuffer sql = new StringBuffer();
					sql.append("AYEAR = '"+ AYEAR[i] +"' ");
					sql.append("AND SMS = '"+ SMS[i] +"' ");
					sql.append("AND substr(TUT_CLASS_CODE,1,1) = '"+ S_CLASS_ABRCODE_CODE[i] +"' ");
					sql.append("AND TUT_CMPS_CODE = '"+ S_CLASS_CMPS_CODE[i] +"' ");
					sql.append("AND CRSNO = '"+ CRSNO[i] +"' ");
					sql.append("AND TUT_CLASS_CODE = '"+ S_CLASS_ID[i] +"' ");
							
					Hashtable hts = new Hashtable();
					hts.put("UNQUAL_TAKE_MK", "Y");
							
					REGT007DAO 	regt007 = new REGT007DAO(dbManager, conn, hts, session);
					int	updateCount2	=	regt007.update(sql.toString());

				}
			}
			
			
			dbManager.commit();

			if (updateCount == 0)
				out.println(DataToJson.faileJson("修改失敗!!"));
			else
				out.println(DataToJson.successJson());	

		}
		catch (Exception ex)
		{

			dbManager.rollback();

			throw ex;
		}
		finally
		{
			dbManager.close();
		}
	}
%>
