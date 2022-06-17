class Public::ReportsController < Public::ApplicationController
  before_action :authenticate_customer!

  ## 新規通報
  def new
    # 通報インスタンスを作成
    @report = Report.new
  end

  ## 通報作成
  def create
    # パラメーターの取得
    @report = Report.new(report_params)
    @report.reports_id = current_customer.id
    @report.reported_id = params[:customer_id]
    # 通報の保存
    if @report.save
      # 前のページへ
      redirect_to customer_path(params[:customer_id]),notice: "通報しました"
    else
      render :new
    end
  end

  # 通報パラメーターの許可
  private

  def report_params
    params.require(:report).permit(:message)
  end

end