package com.ahqy.xmlviewer.controller;

import com.ahqy.xmlviewer.utils.PdfReportM1HeaderFooter;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;


@Controller
public class IndexController {

	private static final String fontPath = "msyh.ttf";
	private static final int normalFontSize=9;
	private static final int titleFontSize =12;
	private static final int headerFontSize =16;
	private BaseFont label;
	private Font font;
	private Font font_title;
	private Font font_header;
	private float pageWidth;



	@RequestMapping(value = "/index", method = {RequestMethod.GET, RequestMethod.POST})
	public String index(HttpServletResponse response) {
		return "index";
	}

	@RequestMapping(value = "/pdf", method = {RequestMethod.GET, RequestMethod.POST})
	public void pdf(HttpServletResponse response,String data,String noNumberPages) {
		response.setContentType("application/pdf");
		String filename = DateFormatUtils.format(new Date(), "yyyyMMddHHmmss");
		response.setHeader("Content-Disposition", "filename="+filename+".pdf");
		try{
			Document document = new Document(PageSize.A4);
			PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
			this.setFooter(writer,noNumberPages);
			writer.setFullCompression();
			writer.setPdfVersion(PdfWriter.VERSION_1_4);
			document.open();
			//预定义字体 和 页面宽度
			label = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
			font = new Font(label, normalFontSize);
			font_title = new Font(label, titleFontSize);
			font_header = new Font(label, headerFontSize);
			pageWidth = document.right()-document.left();
			//执行生成pdf方法
			makePDF(document,data);
			document.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
























	//===========private methods==========
	private void makePDF(Document doc,String data){
		boolean isPrintedForTBXZ = false;
		boolean isPrintedForFM = false;
		boolean isPrintedForBD = false;
		boolean isPrintedForBJ = false;
		boolean isPrintedForZJ =false;
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			java.util.List<LinkedHashMap<String, Object>> list = (java.util.List<LinkedHashMap<String, Object>>) objectMapper.readValue(data, java.util.List.class);
			for (int i = 0 ; list!=null&&i<list.size();i++){
				LinkedHashMap<String,Object> tableData = list.get(i);
				ArrayList celldatas = (ArrayList)tableData.get("data");

				PdfPTable tableitem = getTableBootStrap(doc,String.valueOf(tableData.get("nodetype")),String.valueOf(tableData.get("catetype")),String.valueOf(tableData.get("jobname")));

				if("封面".equals(String.valueOf(tableData.get("nodetype"))) && isPrintedForFM ==false){
					isPrintedForFM = true;
					PdfPCell gcell = new PdfPCell(new Phrase(String.valueOf(tableData.get("jobname")), font_header));
					gcell.setColspan(2);
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(50);
					gcell.setPaddingRight(100);
					gcell.setPaddingLeft(100);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("________________________________________________工程", font_header));
					gcell.setColspan(2);
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(-10);
					gcell.setPaddingBottom(10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("工程量清单", font_header));
					gcell.setColspan(2);
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setPaddingRight(100);
					gcell.setPaddingLeft(100);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("招标人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(80);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________(单位盖章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(80);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("法定代表人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________(签字盖章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("中介机构：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("_________________________________________(盖章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("中介机构法定代表人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________(签字盖章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("审核人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________(签字盖造价工程师执业专用章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("编制人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("________________________(签字盖造价专业人员专用章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("编制时间：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________________", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					try {
						String ewm = String.valueOf(tableData.get("ewm"));
						if(StringUtils.isNotEmpty(ewm)) {
							Image image = Image.getInstance(Base64.decodeBase64(ewm.getBytes()));
							image.scaleToFit(300F, 140F);
							PdfPCell cell = new PdfPCell(image, false);
							cell.setHorizontalAlignment(Element.ALIGN_CENTER);
							cell.setBorder(0);
							cell.setPaddingTop(50);
							cell.setColspan(2);
							tableitem.addCell(cell);
						}
					}catch (Exception ex){
						ex.printStackTrace();
					}
				}else if("填表须知".equals(String.valueOf(tableData.get("nodetype"))) && isPrintedForTBXZ ==false){
					isPrintedForTBXZ = true;
					PdfPCell gcell = new PdfPCell(new Phrase("填表须知", font_header));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingBottom(10);
					gcell.setPaddingTop(50);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("1、工程量清单及其价格式中所有要求签字、盖章的地方，必须有规定的单位和人员签字、盖章。", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_LEFT);
					gcell.setPaddingBottom(10);
					gcell.setPaddingTop(80);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("2、工程量清单及其价格式中任何内容不得随意删除或涂改", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_LEFT);
					gcell.setPaddingBottom(10);
					gcell.setPaddingTop(20);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("3、工程量清单及其价格式中列明的所有需要填报的单价和合价，投标人均应填报，未填报的单价", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_LEFT);
					gcell.setPaddingBottom(10);
					gcell.setPaddingTop(20);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("和合价，视为此项费用已包含在工程量清单的其他单价和合价中。", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_LEFT);
					gcell.setPaddingBottom(10);
					gcell.setPaddingTop(20);
					gcell.setPaddingLeft(20);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("4、金额（价格）均以人民币表示。", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_LEFT);
					gcell.setPaddingBottom(10);
					gcell.setPaddingTop(20);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
				}else if("工程量清单招标控制价(标底)".equals(String.valueOf(tableData.get("nodetype"))) && isPrintedForBD ==false){
					isPrintedForBD = true;
					PdfPCell gcell = new PdfPCell(new Phrase(String.valueOf(tableData.get("jobname")), font_header));
					gcell.setColspan(2);
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(50);
					gcell.setPaddingRight(100);
					gcell.setPaddingLeft(100);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("________________________________________________工程", font_header));
					gcell.setColspan(2);
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(-10);
					gcell.setPaddingBottom(10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("工程量清单招标控制价（标底）", font_header));
					gcell.setColspan(2);
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setPaddingRight(100);
					gcell.setPaddingLeft(100);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase(String.valueOf(tableData.get("totalPrice")+" "), font_title));
					gcell.setColspan(2);
					gcell.setPaddingTop(80);
					gcell.setPaddingLeft(190);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("控制价（标底）（小写）：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(-10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________________", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(-10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase(String.valueOf(tableData.get("totalPriceBig")+" "), font_title));
					gcell.setColspan(2);
					gcell.setPaddingTop(30);
					gcell.setPaddingLeft(190);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("（大写）：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(-10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________________", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(-10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("工程造价咨询单位：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________(单位盖章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("法定代表人或其授权人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________(签字盖章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("审核人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________(签字盖造价工程师执业专用章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("编制人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("________________________(签字盖造价专业人员专用章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("编制时间：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________________", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					try {
						String ewm = String.valueOf(tableData.get("ewm"));
						if(StringUtils.isNotEmpty(ewm)) {
							Image image = Image.getInstance(Base64.decodeBase64(ewm.getBytes()));
							image.scaleToFit(300F, 140F);
							PdfPCell cell = new PdfPCell(image, false);
							cell.setHorizontalAlignment(Element.ALIGN_CENTER);
							cell.setBorder(0);
							cell.setPaddingTop(50);
							cell.setColspan(2);
							tableitem.addCell(cell);
						}
					}catch (Exception ex){
						ex.printStackTrace();
					}
				}else if("工程量清单报价表(投标)".equals(String.valueOf(tableData.get("nodetype"))) && isPrintedForBJ ==false){
					isPrintedForBJ = true;
					PdfPCell gcell = new PdfPCell(new Phrase("工程量清单报价表", font_header));
					gcell.setColspan(2);
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(50);
					gcell.setPaddingRight(100);
					gcell.setPaddingLeft(100);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("投标人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(80);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________(单位盖章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(80);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("法定代表人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________(签字盖章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("审核人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________(签字盖造价工程师执业专用章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("编制人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("________________________(签字盖造价专业人员专用章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("编制时间：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________________", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					try {
						String ewm = String.valueOf(tableData.get("ewm"));
						if(StringUtils.isNotEmpty(ewm)) {
							Image image = Image.getInstance(Base64.decodeBase64(ewm.getBytes()));
							image.scaleToFit(300F, 140F);
							PdfPCell cell = new PdfPCell(image, false);
							cell.setHorizontalAlignment(Element.ALIGN_CENTER);
							cell.setBorder(0);
							cell.setPaddingTop(50);
							cell.setColspan(2);
							tableitem.addCell(cell);
						}
					}catch (Exception ex){
						ex.printStackTrace();
					}
				}else if("投标总价".equals(String.valueOf(tableData.get("nodetype"))) && isPrintedForZJ ==false){
					isPrintedForZJ = true;
					PdfPCell gcell = new PdfPCell(new Phrase("投标总价", font_header));
					gcell.setColspan(2);
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(50);
					gcell.setPaddingRight(100);
					gcell.setPaddingLeft(100);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("建设单位：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(80);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("_____________________________________________", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(80);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase(String.valueOf(tableData.get("jobname")+" "), font_title));
					gcell.setColspan(2);
					gcell.setPaddingTop(30);
					gcell.setPaddingLeft(190);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("工程名称：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(-10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("_____________________________________________", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(-10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);


					gcell = new PdfPCell(new Phrase(String.valueOf(tableData.get("totalPrice")+" "), font_title));
					gcell.setColspan(2);
					gcell.setPaddingTop(30);
					gcell.setPaddingLeft(190);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("投标总价（小写）：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(-10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("_____________________________________________", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(-10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);


					gcell = new PdfPCell(new Phrase(String.valueOf(tableData.get("totalPriceBig")+" "), font_title));
					gcell.setColspan(2);
					gcell.setPaddingTop(30);
					gcell.setPaddingLeft(190);
					gcell.setBorder(0);
					tableitem.addCell(gcell);

					gcell = new PdfPCell(new Phrase("大写：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(-10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("_____________________________________________", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(-10);
					gcell.setBorder(0);
					tableitem.addCell(gcell);


					gcell = new PdfPCell(new Phrase("投标人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(80);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("_______________________________(单位签字盖章盖章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(80);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("法定代表人：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________(签字盖章)", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);


					gcell = new PdfPCell(new Phrase("编制时间：", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_RIGHT);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					gcell = new PdfPCell(new Phrase("______________________________________________", font_title));
					gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					gcell.setPaddingTop(30);
					gcell.setBorder(0);
					tableitem.addCell(gcell);
					try {
						String ewm = String.valueOf(tableData.get("ewm"));
						if(StringUtils.isNotEmpty(ewm)) {
							Image image = Image.getInstance(Base64.decodeBase64(ewm.getBytes()));
							image.scaleToFit(300F, 140F);
							PdfPCell cell = new PdfPCell(image, false);
							cell.setHorizontalAlignment(Element.ALIGN_CENTER);
							cell.setBorder(0);
							cell.setPaddingTop(50);
							cell.setColspan(2);
							tableitem.addCell(cell);
						}
					}catch (Exception ex){
						ex.printStackTrace();
					}
				}
				else if("单项工程造价汇总表".equals(String.valueOf(tableData.get("nodetype")))){
					int[] aligns = {0, 0,Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT,Element.ALIGN_RIGHT};
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
						c.setHorizontalAlignment(aligns[t%aligns.length]);
						tableitem.addCell(c);
					}
				}else if("单位工程造价汇总表".equals(String.valueOf(tableData.get("nodetype")))){
					int[] aligns = {0, 0,Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT,Element.ALIGN_RIGHT};
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
						c.setHorizontalAlignment(aligns[t%aligns.length]);
						tableitem.addCell(c);
					}
				}else if("分部分项工程量清单计价表".equals(String.valueOf(tableData.get("nodetype")))){
					int[] aligns = {0, 0, 0, 0, 0, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT};
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
						c.setHorizontalAlignment(aligns[t%aligns.length]);
						tableitem.addCell(c);
					}
				}else if("措施项目清单计价表(一)".equals(String.valueOf(tableData.get("nodetype")))){
					int[] aligns = {0, 0, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT};
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
						c.setHorizontalAlignment(aligns[t%aligns.length]);
						tableitem.addCell(c);
					}
				}else if("措施项目清单计价表(二)".equals(String.valueOf(tableData.get("nodetype")))){
					int[] aligns= new int[]{0, 0,0,Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT};
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
						c.setHorizontalAlignment(aligns[t%aligns.length]);
						tableitem.addCell(c);
					}
				}else if("零星工作项目计价表".equals(String.valueOf(tableData.get("nodetype")))){
					int[] aligns= new int[]{0, 0,0,Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT};
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
						c.setHorizontalAlignment(aligns[t%aligns.length]);
						tableitem.addCell(c);
					}
				}else if("其他工作项目清单".equals(String.valueOf(tableData.get("nodetype")))){

					int[] aligns= new int[]{0, 0,Element.ALIGN_RIGHT};
					int calc=0;
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						if(celldatas.get(t) instanceof LinkedHashMap){
							LinkedHashMap<String,Object> celldata = (LinkedHashMap<String,Object>)celldatas.get(t);
							PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldata.get("name")),font));
							c.setColspan(3);
							c.setPadding(6);
							c.setBorderColor(new BaseColor(211,211,211));
							c.setHorizontalAlignment(0);
							tableitem.addCell(c);
						}else{
							PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
							c.setPadding(6);
							c.setBorderColor(new BaseColor(211,211,211));
							c.setHorizontalAlignment(aligns[calc%aligns.length]);
							tableitem.addCell(c);
							calc++;
						}

					}
				}else if("规费和税金清单计价表".equals(String.valueOf(tableData.get("nodetype")))){
					int[] aligns= new int[]{0, 0,Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT};
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
						c.setHorizontalAlignment(aligns[t%aligns.length]);
						tableitem.addCell(c);
					}
				}else if("主要材料价格表".equals(String.valueOf(tableData.get("nodetype")))){

					int[]	aligns= new int[]{0, 0,0,0,Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT,0};
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
						c.setHorizontalAlignment(aligns[t%aligns.length]);
						tableitem.addCell(c);
					}
				}else if("需评审的材料表".equals(String.valueOf(tableData.get("nodetype")))){

					int[]	aligns= new int[]{0, 0,0,Element.ALIGN_RIGHT, Element.ALIGN_RIGHT};
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
						c.setHorizontalAlignment(aligns[t%aligns.length]);
						tableitem.addCell(c);
					}
				}else if("分部分项工程工程量清单综合单价计算表".equals(String.valueOf(tableData.get("nodetype")))){
					for (int t =0 ; celldatas!=null&&t<celldatas.size();){
						if("-Data-Start-".equals(String.valueOf(celldatas.get(t)))){
							t++;
							PdfPTable row_table = new PdfPTable(12);
							float[] widths = {1,1,4,1,1,1,1,1,1,1,1,1};
							row_table.setWidths(widths);
							row_table.setWidthPercentage(100);
							row_table.setTotalWidth(pageWidth);
							row_table.setLockedWidth(true);

							int calc=1;
							for (int k = t; k<t+12;k++){
								PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(k)),font));
								c.setPadding(6);
								c.setBorderColor(new BaseColor(211,211,211));
								if(calc==1||calc==5||calc==9 ||calc==4||calc==8||calc==12){
									c.setColspan(2);
								}else if(calc==2||calc==6||calc==10){
									c.setColspan(5);
								}else{
									c.setColspan(3);
								}
								row_table.addCell(c);
								if(calc == 13){
									calc = 0;
								}
								calc++;
							}
							String[] headers = {"序号", "定额编号", "工程内容", "单位", "数量", "人工费", "材料费", "机械费", "管理费","利润","风险费","小计"};
							for (String headerItem : headers) {
								row_table.addCell(getHeaderCell(headerItem));
							}

							for (int k = t+12; k< celldatas.size();k++){
								if("-Data-Start-".equals(String.valueOf(celldatas.get(k)))){
									t=k;
									break;
								}
								String text=String.valueOf(celldatas.get(k));
								PdfPCell c = new PdfPCell(new Phrase(text,font));
								c.setPadding(6);
								c.setBorderColor(new BaseColor(211,211,211));
								row_table.addCell(c);
								if(k == celldatas.size()-1){
									t=k+1;
									break;
								}
							}
							PdfPCell row = new PdfPCell(row_table);
							tableitem.addCell(row);
							PdfPCell c = new PdfPCell(new Phrase(" ",font));
							c.setColspan(12);
							c.setPadding(6);
//							c.setBorderColor(BaseColor.WHITE);
							c.setBorderWidthTop(1);
							c.setBorderColorTop(BaseColor.GRAY);
							c.setBorderColorLeft(BaseColor.WHITE);
							c.setBorderColorRight(BaseColor.WHITE);
							tableitem.addCell(c);
						}
					}
				}else if("措施项目费计算表(一)".equals(String.valueOf(tableData.get("nodetype")))){
					int[] aligns = {0, 0,0,Element.ALIGN_RIGHT, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT};
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
						c.setHorizontalAlignment(aligns[t%aligns.length]);
						tableitem.addCell(c);
					}
				}else if("措施项目费计算表(二)".equals(String.valueOf(tableData.get("nodetype")))){
					int[] aligns = {0, 0,0, Element.ALIGN_RIGHT, Element.ALIGN_RIGHT};
					PdfPTable row_table = null;
					for (int t =0 ; celldatas!=null&&t<celldatas.size();t++){
						if(celldatas.get(t) instanceof ArrayList){
							if(row_table == null){
								row_table = new PdfPTable(12);
								float[] widths = {1,2,2,2,2,2,2,2,2,2,2,2};
								row_table.setWidths(widths);
								row_table.setWidthPercentage(100);
								row_table.setTotalWidth(pageWidth);
								row_table.setLockedWidth(true);
								ArrayList dh = (ArrayList)celldatas.get(t);
								int calc = 0;
								for (int k=0;dh!=null&&k<dh.size();k++){
									PdfPCell c = new PdfPCell(new Phrase(String.valueOf(dh.get(k)),font));
									c.setPadding(6);
									c.setBorderColor(new BaseColor(211,211,211));
									if(calc==1){
										c.setColspan(8);
									}
									if(calc % 5==0){
										calc = 0;
									}
									row_table.addCell(c);
									calc++;
								}
								String[] headers = {"序号", "定额编号", "工程内容", "单位", "数量", "人工费", "材料费", "机械费", "管理费","利润","风险费","小计"};
								for (String headerItem : headers) {
									row_table.addCell(getHeaderCell(headerItem));
								}
								continue;
							}else{
								PdfPCell tc = new PdfPCell(row_table);
								tc.setColspan(12);
								tableitem.addCell(tc);

								PdfPCell cb = new PdfPCell(new Phrase(" ",font));
								cb.setColspan(12);
								cb.setPadding(6);
								cb.setBorderColor(BaseColor.WHITE);
								tableitem.addCell(cb);

								row_table = new PdfPTable(12);
								float[] widths = {1,2,2,2,2,2,2,2,2,2,2,2};
								row_table.setWidths(widths);
								row_table.setWidthPercentage(100);
								row_table.setTotalWidth(pageWidth);
								row_table.setLockedWidth(true);
								ArrayList dh = (ArrayList)celldatas.get(t);
								int calc = 0;
								for (int k=0;dh!=null&&k<dh.size();k++){
									PdfPCell c = new PdfPCell(new Phrase(String.valueOf(dh.get(k)),font));
									c.setPadding(6);
									c.setBorderColor(new BaseColor(211,211,211));
									if(calc==1){
										c.setColspan(8);
									}
									if(calc % 5==0){
										calc = 0;
									}
									row_table.addCell(c);
									calc++;
								}
								String[] headers = {"序号", "定额编号", "工程内容", "单位", "数量", "人工费", "材料费", "机械费", "管理费","利润","风险费","小计"};
								for (String headerItem : headers) {
									row_table.addCell(getHeaderCell(headerItem));
								}
								continue;
							}
						}

						PdfPCell c = new PdfPCell(new Phrase(String.valueOf(celldatas.get(t)),font));
						c.setPadding(6);
						c.setBorderColor(new BaseColor(211,211,211));
//						c.setHorizontalAlignment(aligns[t%aligns.length]);
						row_table.addCell(c);

					}
				}
				doc.add(tableitem);
				doc.newPage();
			}
		}catch (Exception e){
			e.printStackTrace();
		}
	}

	/**
	 *
	 * @param doc
	 * @param nodetype 节点类型
	 * @param catetype 目录类型
	 * @return
	 */
	private PdfPTable getTableBootStrap(Document doc,String nodetype,String catetype,String jobname){
		try {
			if ("封面".equals(nodetype)) {
				PdfPTable table = new PdfPTable(2);
				float[] widths = {1.5f, 4};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				table.setTotalWidth(pageWidth);
				table.setLockedWidth(true);
				return table;
			}else if ("填表须知".equals(nodetype)) {
				PdfPTable table = new PdfPTable(1);
				table.setTotalWidth(pageWidth);
				table.setLockedWidth(true);
				return table;
			}else if ("工程量清单招标控制价(标底)".equals(nodetype)) {
				PdfPTable table = new PdfPTable(2);
				float[] widths = {1.5f, 3.5f};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				table.setTotalWidth(pageWidth);
				table.setLockedWidth(true);
				return table;
			}else if ("工程量清单报价表(投标)".equals(nodetype)) {
				PdfPTable table = new PdfPTable(2);
				float[] widths = {1f, 3.5f};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				table.setTotalWidth(pageWidth);
				table.setLockedWidth(true);
				return table;
			}else if ("投标总价".equals(nodetype)) {
				PdfPTable table = new PdfPTable(2);
				float[] widths = {1.5f, 3.5f};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				table.setTotalWidth(pageWidth);
				table.setLockedWidth(true);
				return table;
			}else if ("单项工程造价汇总表".equals(nodetype)) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 6);
				table.setHeaderRows(4);
				float[] widths = {1, 4, 2,2,2,2};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号", "单项工程", "金额（元）"};
					for (String headerItem : headers) {
						PdfPCell headercell = getHeaderCell(headerItem);
						headercell.setRowspan(2);
						table.addCell(headercell);
					}

					PdfPCell headercell1 = getHeaderCell("其中（元）");
					headercell1.setColspan(3);
					table.addCell(headercell1);
					PdfPCell headercell2 = getHeaderCell("安全防护、文明施工费");
					table.addCell(headercell2);
					PdfPCell headercell3 = getHeaderCell("规费");
					table.addCell(headercell3);
					PdfPCell headercell4 = getHeaderCell("评标价");
					table.addCell(headercell4);
				}
				return table;
			}else if ("单位工程造价汇总表".equals(nodetype)) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 6);
				table.setHeaderRows(4);
				float[] widths = {1, 4, 2,2,2,2};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号", "单位工程", "金额（元）"};
					for (String headerItem : headers) {
						PdfPCell headercell = getHeaderCell(headerItem);
						headercell.setRowspan(2);
						table.addCell(headercell);
					}

					PdfPCell headercell1 = getHeaderCell("其中（元）");
					headercell1.setColspan(3);
					table.addCell(headercell1);
					PdfPCell headercell2 = getHeaderCell("安全防护、文明施工费");
					table.addCell(headercell2);
					PdfPCell headercell3 = getHeaderCell("规费");
					table.addCell(headercell3);
					PdfPCell headercell4 = getHeaderCell("评标价");
					table.addCell(headercell4);
				}
				return table;
			}else if (StringUtils.equals(nodetype, "分部分项工程量清单计价表")) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 9);
				table.setHeaderRows(3);
				float[] widths = {1, 2.3f, 2, 4.2f, 1, 2.5f, 1.5f, 2, 1.5f};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号", "项目编码", "项目名称", "项目特征", "计数单位", "工程数量", "综合单价", "合价", "其中人工费"};
					for (String headerItem : headers) {
						table.addCell(getHeaderCell(headerItem));
					}
				}
				return table;
			}else if ("措施项目清单计价表(一)".equals(nodetype) ) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 5);
				table.setHeaderRows(3);
				float[] widths = {1, 5,2,2,2};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号", "项目名称", "取费基数", "费率", "金额（元）"};
					for (String headerItem : headers) {
						table.addCell(getHeaderCell(headerItem));
					}
				}
				return table;
			}else if ("措施项目清单计价表(二)".equals(nodetype)) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 7);
				table.setHeaderRows(3);
				float[] widths = {1.3f, 4.5f,2,2,2,2,2};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号", "项目名称", "计量单位", "工程数量", "单价（元）", "合价（元）", "人工费 "};
					for (String headerItem : headers) {
						table.addCell(getHeaderCell(headerItem));
					}
				}
				return table;
			}else if ("零星工作项目计价表".equals(nodetype)) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 6);
				table.setHeaderRows(4);
				if (table != null) {
					String[] headers = {"序号", "项目名称", "计数单位", "数量"};//, "金额（元）"
					for (String headerItem : headers) {
						PdfPCell headercell = getHeaderCell(headerItem);
						headercell.setRowspan(2);
						table.addCell(headercell);
					}

					PdfPCell headercell1 = getHeaderCell("金额（元）");
					headercell1.setColspan(2);
					table.addCell(headercell1);
					PdfPCell headercell2 = getHeaderCell("综合单价");
					table.addCell(headercell2);
					PdfPCell headercell3 = getHeaderCell("合价");
					table.addCell(headercell3);
				}
				return table;
			}else if ("其他工作项目清单".equals(nodetype)) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 3);
				table.setHeaderRows(3);
				float[] widths = {1, 7,2};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号", "名称", "金额"};
					for (String headerItem : headers) {
						table.addCell(getHeaderCell(headerItem));
					}
				}
				return table;
			}else if ("规费和税金清单计价表".equals(nodetype)) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 5);
				table.setHeaderRows(3);
				float[] widths = {1, 5,2,2,2};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号","项目名称", "取费基数", "费率（%）","金额（元)"};
					for (String headerItem : headers) {
						table.addCell(getHeaderCell(headerItem));
					}
				}
				return table;
			}else if ("主要材料价格表".equals(nodetype)) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 8);
				table.setHeaderRows(3);
				float[] widths = {1, 2,4,2,2,2,2,2};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号","材料编码", "材料名称及特殊要求", "单位","数量","单价(元)","合价(元)","备注"};
					for (String headerItem : headers) {
						table.addCell(getHeaderCell(headerItem));
					}
				}
				return table;
			}else if ("需评审的材料表".equals(nodetype)) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 5);
				table.setHeaderRows(3);
				float[] widths = {1,4,2,2,2};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号", "材料名称及特殊要求", "单位","单价（元）","总用量"};
					for (String headerItem : headers) {
						table.addCell(getHeaderCell(headerItem));
					}
				}
				return table;
			}else if ("分部分项工程工程量清单综合单价计算表".equals(nodetype) ) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 1);
				table.setHeaderRows(2);
				return table;
			}else if ("措施项目费计算表(一)".equals(nodetype)) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 6);
				table.setHeaderRows(3);
				float[] widths = {1,4,2,2,2,2};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号", "项目名称", "单位","取费基数","费率","金额(元)"};
					for (String headerItem : headers) {
						table.addCell(getHeaderCell(headerItem));
					}
				}
				return table;
			}else if ("措施项目费计算表(二)".equals(nodetype)) {
				PdfPTable table = getNormalTableHeader(doc, nodetype, jobname, 12);
				table.setHeaderRows(3);
				float[] widths = {1,2,2,2,2,2,2,2,2,2,2,2};
				table.setWidths(widths);
				table.setWidthPercentage(100);
				if (table != null) {
					String[] headers = {"序号", "项目名称", "计量单位","工程数量","综合单价"};
					for (String headerItem : headers) {
						PdfPCell hc = getHeaderCell(headerItem);
						if(headerItem.equals("项目名称")){
							hc.setColspan(8);
						}
						table.addCell(hc);
					}
				}
				return table;
			}
		}catch (Exception ex) {
			return null;
		}
		return null;
	}

	private PdfPTable getNormalTableHeader(Document doc,String nodetype,String dwgc,int colNumbers){
		try {
			PdfPTable table = new PdfPTable(colNumbers);
			table.setTotalWidth(pageWidth);
			table.setLockedWidth(true);

			PdfPCell gcell = new PdfPCell(new Phrase(nodetype, font_title));
			gcell.setColspan(colNumbers);
			gcell.setHorizontalAlignment(Element.ALIGN_CENTER);
			gcell.setPaddingBottom(10);
			gcell.setPaddingTop(-10);
			gcell.setBorder(0);
			table.addCell(gcell);

			PdfPCell gcell2 = new PdfPCell(new Phrase(dwgc, font));
			gcell2.setColspan(colNumbers);//%2==0?colNumbers/2:colNumbers/2+1
			gcell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			gcell2.setPaddingBottom(10);
			gcell2.setBorder(0);
			table.addCell(gcell2);
			return table;
		}catch (Exception ex){
			ex.printStackTrace();
			return null;
		}
	}

	private void setFooter(PdfWriter writer,String noNumberPages) throws DocumentException, IOException {
//HeaderFooter headerFooter = new HeaderFooter(this);
//更改事件，瞬间变身 第几页/共几页 模式。
		PdfReportM1HeaderFooter headerFooter = new PdfReportM1HeaderFooter();//就是上面那个类
		try {
			headerFooter.setNoNumberPages(Integer.parseInt(noNumberPages));
		}catch (Exception ex){
			ex.printStackTrace();
		}
		writer.setBoxSize("art",PageSize.A4);
		writer.setPageEvent(headerFooter);
	}

	private PdfPCell getHeaderCell(String headertext){
		PdfPCell headercell = new PdfPCell(new Phrase(headertext, font));
		headercell.setHorizontalAlignment(Element.ALIGN_CENTER);
		headercell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		headercell.setPadding(10);
		headercell.setBorderColor(new BaseColor(211, 211, 211));
		headercell.setBackgroundColor(new BaseColor(233, 233, 233));
		return headercell;
	}
}
