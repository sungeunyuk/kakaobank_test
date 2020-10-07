/*
1번 문제
*/

use KAKAOBANK;

SHOW TABLE STATUS LIKE 'KAKAOBANK.MENU_LOG';

SHOW INDEX FROM KAKAOBANK.MENU_LOG;

ANALYZE TABLE KAKAOBANK.MENU_LOG;

CREATE INDEX IDX_MENU_LOG_MENU_NAME ON KAKAOBANK.MENU_LOG (MENU_NM);

-- PRIMARY KEY (LOG_TKTM, LOG_ID)
-- EXPLAIN FORMAT=JSON


select  rank_menu as '구분',
        ifnull(group_concat( if (dayofweek='월요일' , concat(menu_nm , concat(' (',convert(cnt,char)) ,'건)')  , null) ) , '-') as '월요일' ,
        ifnull(group_concat( if (dayofweek='화요일' , concat(menu_nm , concat(' (',convert(cnt,char)) ,'건)')  , null) ) , '-') as '화요일' ,
        ifnull(group_concat( if (dayofweek='수요일' , concat(menu_nm , concat(' (',convert(cnt,char)) ,'건)')  , null) ) , '-') as '수요일' ,
        ifnull(group_concat( if (dayofweek='목요일' , concat(menu_nm , concat(' (',convert(cnt,char)) ,'건)')  , null) ) , '-') as '목요일' ,
        ifnull(group_concat( if (dayofweek='금요일' , concat(menu_nm , concat(' (',convert(cnt,char)) ,'건)')  , null) ) , '-') as '금요일' ,
        ifnull(group_concat( if (dayofweek='토요일' , concat(menu_nm , concat(' (',convert(cnt,char)) ,'건)')  , null) ) , '-') as '토요일' ,
        ifnull(group_concat( if (dayofweek='일요일' , concat(menu_nm , concat(' (',convert(cnt,char)) ,'건)')  , null) ) , '-') as '일요일'

from
(
    select a.* , row_number() over(partition by dayofweek order by cnt desc, menu_nm asc) as 'rank_menu'
    from (
        select -- Log_tktm ,
            case WEEKDAY(Log_tktm) -- 날짜 요일 추출 함수
            when '0' then '월요일'
            when '1' then '화요일'
            when '2' then '수요일'
            when '3' then '목요일'
            when '4' then '금요일'
            when '5' then '토요일'
            when '6' then '일요일'
            end as dayofweek ,
            menu_nm ,
            count(*) cnt -- 요일별 메뉴별 건수
        from KAKAOBANK.MENU_LOG
        where MENU_NM not in ('logout' , 'login')
        -- 조건 로그인/로그아웃 제외
        -- where 절 칼럼 인덱싱
        group by 1,2
    ) a
)a
where rank_menu <= 10  -- top 10 menu only
group by rank_menu
;


/*
실행 계획
id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1','PRIMARY','<derived2>',NULL,'ALL',NULL,NULL,NULL,NULL,'415','33.33','Using where; Using filesort'
'2','DERIVED','<derived3>',NULL,'ALL',NULL,NULL,NULL,NULL,'415','100.00','Using filesort'
'3','DERIVED','MENU_LOG',NULL,'range','IDX_MENU_LOG_MENU_NAME','IDX_MENU_LOG_MENU_NAME','203',NULL,'415','100.00','Using where; Using index; Using temporary'


{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "187.51"
    },
    "grouping_operation": {
      "using_filesort": true,
      "cost_info": {
        "sort_cost": "138.32"
      },
      "table": {
        "table_name": "a",
        "access_type": "ALL",
        "rows_examined_per_scan": 415,
        "rows_produced_per_join": 138,
        "filtered": "33.33",
        "cost_info": {
          "read_cost": "35.36",
          "eval_cost": "13.83",
          "prefix_cost": "49.19",
          "data_read_per_join": "32K"
        },
        "used_columns": [
          "dayofweek",
          "menu_nm",
          "cnt",
          "rank_menu"
        ],
        "attached_condition": "(`a`.`rank_menu` <= 10)",
        "materialized_from_subquery": {
          "using_temporary_table": true,
          "dependent": false,
          "cacheable": true,
          "query_block": {
            "select_id": 2,
            "cost_info": {
              "query_cost": "464.19"
            },
            "windowing": {
              "windows": [
                {
                  "name": "<unnamed window>",
                  "using_filesort": true,
                  "filesort_key": [
                    "`dayofweek`",
                    "`cnt` desc",
                    "`menu_nm`"
                  ],
                  "functions": [
                    "row_number"
                  ]
                }
              ],
              "cost_info": {
                "sort_cost": "415.00"
              },
              "table": {
                "table_name": "a",
                "access_type": "ALL",
                "rows_examined_per_scan": 415,
                "rows_produced_per_join": 415,
                "filtered": "100.00",
                "cost_info": {
                  "read_cost": "7.69",
                  "eval_cost": "41.50",
                  "prefix_cost": "49.19",
                  "data_read_per_join": "94K"
                },
                "used_columns": [
                  "dayofweek",
                  "menu_nm",
                  "cnt"
                ],
                "materialized_from_subquery": {
                  "using_temporary_table": true,
                  "dependent": false,
                  "cacheable": true,
                  "query_block": {
                    "select_id": 3,
                    "cost_info": {
                      "query_cost": "94.42"
                    },
                    "grouping_operation": {
                      "using_temporary_table": true,
                      "using_filesort": false,
                      "table": {
                        "table_name": "MENU_LOG",
                        "access_type": "range",
                        "possible_keys": [
                          "IDX_MENU_LOG_MENU_NAME"
                        ],
                        "key": "IDX_MENU_LOG_MENU_NAME",
                        "used_key_parts": [
                          "MENU_NM"
                        ],
                        "key_length": "203",
                        "rows_examined_per_scan": 415,
                        "rows_produced_per_join": 415,
                        "filtered": "100.00",
                        "using_index": true,
                        "cost_info": {
                          "read_cost": "52.92",
                          "eval_cost": "41.50",
                          "prefix_cost": "94.42",
                          "data_read_per_join": "155K"
                        },
                        "used_columns": [
                          "LOG_TKTM",
                          "LOG_ID",
                          "MENU_NM"
                        ],
                        "attached_condition": "(`KAKAOBANK`.`MENU_LOG`.`MENU_NM` not in ('logout','login'))"
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

*/


/*
결과

구분, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일, 일요일
'1','가이드 (9건)','이체내역 (22건)','세이프박스 (12건)','이체내역 (5건)','추천 (5건)','모임통장 (10건)','정기예금 (3건)'
'2','세이프박스 (8건)','추천 (20건)','가이드 (10건)','내카드 (4건)','내정보 (4건)','가이드 (7건)','가이드 (2건)'
'3','내신용정보 (6건)','내카드 (19건)','추천 (10건)','추천 (4건)','이체내역 (4건)','내정보 (7건)','내신용정보 (2건)'
'4','내카드 (6건)','세이프박스 (18건)','정기예금 (9건)','내신용정보 (3건)','내카드 (3건)','세이프박스 (6건)','세이프박스 (2건)'
'5','모임통장 (6건)','가이드 (17건)','내신용정보 (7건)','세이프박스 (3건)','모임통장 (3건)','이체내역 (5건)','이체내역 (2건)'
'6','추천 (6건)','내신용정보 (17건)','이체내역 (7건)','정기예금 (1건)','세이프박스 (3건)','추천 (5건)','내정보 (1건)'
'7','카드이용내역 (6건)','정기예금 (17건)','내정보 (4건)','카드이용내역 (1건)','내신용정보 (2건)','카드이용내역 (5건)','내카드 (1건)'
'8','내정보 (5건)','모임통장 (14건)','내카드 (4건)','-','가이드 (1건)','내카드 (4건)','-'
'9','이체내역 (5건)','카드이용내역 (13건)','모임통장 (4건)','-','정기예금 (1건)','내신용정보 (2건)','-'
'10','정기예금 (5건)','내정보 (11건)','카드이용내역 (3건)','-','카드이용내역 (1건)','정기예금 (1건)','-'


*/


