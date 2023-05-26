# frozen_string_literal: true

module MetaTagsHelper
  # rubocop:disable Metrics/MethodLength
  def default_meta_tags
    {
      site: 'Skinmate（スキンメイト）',
      reverse: true,
      charset: 'utf-8',
      description: 'Skinmateはあなたの日々のスキンケアをサポートする、化粧品の使用サイクル管理アプリです。使い切り予定日の予測や1ヶ月の消費金額の計算を自動で行います。',
      keywords: '化粧水, 化粧品, 使用サイクル, 管理, 消費金額',
      viewport: 'width=device-width, initial-scale=1.0',
      og: {
        title: :title,
        type: 'website',
        site_name: 'SkinMate',
        description: :description,
        image: image_url('ogp.png'),
        url: 'https://skinmate.fly.dev/'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@skinmate_app',
        description: :description,
        image: image_url('ogp.png'),
        domain: 'https://skinmate.fly.dev/'
      }
    }
  end
  # rubocop:enable Metrics/MethodLength

  def top_meta_tags
    default_meta_tags.deep_merge({
                                   title:,
                                   og: {
                                     title: title || 'Skinmate（スキンメイト）'
                                   },
                                   twitter: {
                                     title: title || 'Skinmate（スキンメイト）'
                                   }
                                 })
  end
end
