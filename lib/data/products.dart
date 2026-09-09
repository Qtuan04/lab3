import '../models/product.dart';

const List<Product> allProducts = [
  Product(
    id: 1,
    name: 'iPhone 16 Pro',
    price: 24990000,
    oldPrice: 28990000,
    discount: 14,
    rating: 4.9,
    reviewCount: 2341,
    category: 'Điện thoại',
    imageUrl:
        'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80',
    description:
        'iPhone 16 Pro với chip A18 Pro mạnh mẽ nhất từ trước đến nay. Camera 48MP thế hệ mới với khả năng quay video 4K/120fps, màn hình Super Retina XDR 6.3 inch ProMotion 120Hz. Thiết kế titanium sang trọng, bền bỉ cùng pin cả ngày dài.',
    specs: [
      'Màn hình: 6.3" Super Retina XDR 120Hz',
      'Chip: Apple A18 Pro',
      'Camera chính: 48MP Fusion',
      'Pin: 4685 mAh',
      'RAM: 8GB',
      'Bộ nhớ: 256GB',
    ],
  ),
  Product(
    id: 2,
    name: 'Samsung Galaxy S25 Ultra',
    price: 26990000,
    oldPrice: 31990000,
    discount: 16,
    rating: 4.8,
    reviewCount: 1876,
    category: 'Điện thoại',
    imageUrl:
        'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=600&q=80',
    description:
        'Samsung Galaxy S25 Ultra trang bị bút S Pen tích hợp AI, chip Snapdragon 8 Elite, màn hình Dynamic AMOLED 2X 6.9 inch. Camera 200MP đỉnh cao cùng zoom quang học 10x, pin 5000mAh sạc nhanh 45W.',
    specs: [
      'Màn hình: 6.9" Dynamic AMOLED 2X 120Hz',
      'Chip: Snapdragon 8 Elite',
      'Camera chính: 200MP',
      'Pin: 5000 mAh',
      'RAM: 12GB',
      'Bộ nhớ: 256GB',
    ],
  ),
  Product(
    id: 3,
    name: 'MacBook Pro M4',
    price: 49990000,
    oldPrice: 54990000,
    discount: 9,
    rating: 4.9,
    reviewCount: 983,
    category: 'Laptop',
    imageUrl:
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=600&q=80',
    description:
        'MacBook Pro với chip Apple M4 thế hệ mới mang lại hiệu năng đột phá. Màn hình Liquid Retina XDR 14.2 inch, thời lượng pin lên đến 22 giờ. Hoàn hảo cho các chuyên gia sáng tạo nội dung và lập trình viên.',
    specs: [
      'Màn hình: 14.2" Liquid Retina XDR',
      'Chip: Apple M4',
      'RAM: 16GB Unified Memory',
      'SSD: 512GB',
      'Pin: 22 giờ',
      'Trọng lượng: 1.55 kg',
    ],
  ),
  Product(
    id: 4,
    name: 'iPad Pro M4',
    price: 22990000,
    oldPrice: 25990000,
    discount: 12,
    rating: 4.8,
    reviewCount: 745,
    category: 'Tablet',
    imageUrl:
        'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=600&q=80',
    description:
        'iPad Pro M4 mỏng nhất từ trước đến nay với thiết kế tandem OLED đột phá, chip M4 siêu mạnh. Màn hình Ultra Retina XDR 11 inch với độ sáng 1000 nit, hỗ trợ Apple Pencil Pro và bàn phím Magic Keyboard.',
    specs: [
      'Màn hình: 11" Ultra Retina XDR OLED',
      'Chip: Apple M4',
      'RAM: 8GB',
      'Bộ nhớ: 256GB',
      'Camera: 12MP',
      'Pin: 10 giờ',
    ],
  ),
  Product(
    id: 5,
    name: 'AirPods Pro 2',
    price: 6490000,
    oldPrice: 7490000,
    discount: 13,
    rating: 4.7,
    reviewCount: 3102,
    category: 'Tai nghe',
    imageUrl:
        'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=600&q=80',
    description:
        'AirPods Pro thế hệ 2 với chip H2 mang đến chất lượng âm thanh vượt trội. Chống ồn chủ động ANC thế hệ mới, âm thanh không gian cá nhân hóa, thời lượng pin lên đến 30 giờ với hộp sạc.',
    specs: [
      'Chip: Apple H2',
      'ANC: Chủ động thế hệ mới',
      'Pin tai nghe: 6 giờ',
      'Pin tổng (kèm hộp): 30 giờ',
      'Kết nối: Bluetooth 5.3',
      'Chống nước: IPX4',
    ],
  ),
  Product(
    id: 6,
    name: 'Apple Watch Series 10',
    price: 10990000,
    oldPrice: 12490000,
    discount: 12,
    rating: 4.8,
    reviewCount: 1254,
    category: 'Đồng hồ',
    imageUrl:
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&w=600&q=80',
    description:
        'Apple Watch Series 10 mỏng nhất từ trước đến nay với màn hình lớn hơn, sáng hơn. Tính năng theo dõi sức khỏe tiên tiến: đo nhịp tim, SpO2, ECG, phát hiện ngã và nhiều hơn nữa. Vỏ nhôm nhẹ sang trọng.',
    specs: [
      'Màn hình: Always-On Retina LTPO OLED',
      'Chip: S10',
      'Pin: 18 giờ',
      'Chống nước: 50m',
      'Cảm biến: Tim, SpO2, ECG, Nhiệt độ',
      'Kết nối: GPS + Cellular',
    ],
  ),
  Product(
    id: 7,
    name: 'ASUS TUF Gaming F15',
    price: 19990000,
    oldPrice: 23490000,
    discount: 15,
    rating: 4.6,
    reviewCount: 621,
    category: 'Laptop',
    imageUrl:
        'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=600&q=80',
    description:
        'ASUS TUF Gaming F15 với chip Intel Core i7 thế hệ 13, GPU NVIDIA RTX 4060, màn hình FHD 144Hz. Thiết kế chắc chắn chuẩn quân đội MIL-STD-810H, tản nhiệt tối ưu, pin 90Wh dài lâu.',
    specs: [
      'Màn hình: 15.6" FHD IPS 144Hz',
      'CPU: Intel Core i7-13620H',
      'GPU: NVIDIA RTX 4060 8GB',
      'RAM: 16GB DDR5',
      'SSD: 512GB NVMe',
      'Pin: 90Wh',
    ],
  ),
  Product(
    id: 8,
    name: 'Sony WH-1000XM5',
    price: 7990000,
    oldPrice: 9490000,
    discount: 16,
    rating: 4.9,
    reviewCount: 2087,
    category: 'Tai nghe',
    imageUrl:
        'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?auto=format&fit=crop&w=600&q=80',
    description:
        'Sony WH-1000XM5 với công nghệ chống ồn hàng đầu thế giới, 8 microphone, chip QN1 và V1 kép. Âm thanh Hi-Res không dây, pin 30 giờ, sạc nhanh 3 phút nghe 3 giờ. Thiết kế gọng nhẹ siêu thoải mái.',
    specs: [
      'Chip: QN1 + V1 kép',
      'ANC: 8 microphone',
      'Âm thanh: Hi-Res Wireless (LDAC)',
      'Pin: 30 giờ',
      'Sạc nhanh: 3 phút = 3 giờ',
      'Kết nối: Bluetooth 5.2, Multipoint',
    ],
  ),
];
