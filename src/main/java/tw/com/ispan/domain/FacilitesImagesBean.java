package tw.com.ispan.domain;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "facility_images")
public class FacilitesImagesBean {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "image_id")
	private Integer imageId;

	// 設定 FK 關聯到 facilities 表的 facility_id 欄位
	@ManyToOne
	@JoinColumn(name = "facility_id", referencedColumnName = "facility_id")
	@Column(name = "facility_id")
	private Integer facilityId;

	@Column(name = "image_url")
	private String imageUrl;

	@Column(name = "image_description")
	private String imageDescription;

	@Column(name = "sort_order")
	private Integer sortOrder;

	@Column(name = "created_at")
	private LocalDateTime createdAt;

	@Column(name = "update_at")
	private LocalDateTime updatedAt;
}
